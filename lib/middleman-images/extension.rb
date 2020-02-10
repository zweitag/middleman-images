require 'middleman-core'
require 'pathname'
require 'padrino-helpers'

module Middleman
  module Images
    class Extension < ::Middleman::Extension
      option :optimize, false, 'Whether to optimize images by default'
      option :image_optim, {}, 'Default options for image_optim'
      option :ignore_original, false, 'Whether to ignore original images in build'
      option :cache_dir, 'cache', 'Specification of cache folder'

      helpers do
        def image_tag(url, options = {})
          process_options = options.slice(:resize, :optimize)
          options = { src: image_path(url, process_options) }.update(options.except(:resize, :optimize))
          super
        end

        def image_path(url, process_options = {})
          url = extensions[:images].image(url, process_options)
          super url
        end
      end

      def manipulate_resource_list(resources)
        manipulator.manipulate_resource_list(resources)
      end

      def template_context
        @template_context ||= app.template_context_class.new(app, {}, {})
      end

      def process(source, process_options)
        destination_path(source, process_options).tap do |dest_url|
          unless app.sitemap.find_resource_by_path(dest_url)
            image = Image.new(app.sitemap, dest_url, source.source_file, process_options.merge(cache_dir: options[:cache_dir]))
            manipulator.add image
          end
        end
      end

      def image(url, process_options)
        source = app.sitemap.find_resource_by_path(absolute_image_path(url))
        return url if source.nil?

        process_options[:image_optim] = options[:image_optim]
        process_options[:optimize] = options[:optimize] unless process_options.key?(:optimize)

        if process_options[:resize] || process_options[:optimize]
          url = process(source, process_options)
        else
          manipulator.preserve_original source
        end
        url
      end

      def initialize(app, options_hash = {}, &block)
        super
        @manipulator = Manipulator.new(@app, options[:ignore_original])
      end

      private

      attr_reader :manipulator

      def destination_path(source, options)
        destination = source.normalized_path.sub(/#{source.ext}$/, '')
        destination += '-' + template_context.escape_html(options[:resize]) if options[:resize]
        destination += '-opt' if options[:optimize]
        destination + source.ext
      end

      def absolute_image_path(url)
        absolute_path = url.start_with?('/') || url.start_with?(app.config[:images_dir])
        absolute_path ? url : app.config[:images_dir] + '/' + url
      end
    end
  end
end
