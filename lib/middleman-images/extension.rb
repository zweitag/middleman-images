require 'middleman-core'
require 'pathname'
require 'padrino-helpers'

module Middleman
  module Images
    class Extension < ::Middleman::Extension

      option :optimize, true, 'Whether to optimize images by default'
      option :image_optim, {}, 'Default options for image_optim'

      helpers do
        def image_tag(url, options = {})
          process_options = options.slice(:resize, :optimize)
          options = { :src => image_path(url, process_options) }.update(options.except(:resize, :optimize))
          super
        end

        def image_path(url, process_options = {})
          url = extensions[:images].image(url, process_options)
          super url
        end
      end

      def template_context
        @template_context ||= app.template_context_class.new(app, {}, {})
      end

      def process(source, process_options)
        destination_path(source, process_options).tap do |dest_url|
          unless app.sitemap.find_resource_by_path(dest_url)
            logger.info "== Images: Processing #{dest_url}"
            image = Image.new(@app, source.source_file, dest_url, process_options)
            app.sitemap.register_resource_list_manipulator(:images, image, 40)
            app.sitemap.rebuild_resource_list!(:images)
          end
        end
      end

      def image(url, process_options)
        process_options[:image_optim] = self.options[:image_optim]
        process_options[:optimize] = self.options[:optimize] unless process_options.key?(:optimize)
        if process_options[:resize] || process_options[:optimize]
          source = app.sitemap.find_resource_by_path(absolute_image_path(url))
          url = process(source, process_options) if source
        end
        url
      end

      def initialize(app, options_hash={}, &block)
        super
      end

      def before_build(builder)
        # trigger our image_tag helper
        rack = builder.instance_variable_get(:@rack)
        builder.app.sitemap.resources.each do |resource|
          rack.get(::URI.escape(resource.request_path)) unless resource.binary?
        end
      end

      private

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
