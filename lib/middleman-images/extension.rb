require 'middleman-core'
require 'pathname'

module Middleman
  module Images
    class Extension < ::Middleman::Extension

      option :optimize, true, 'Whether to optimize images by default'
      option :image_optim, {}, 'Default options for image_optim'

      helpers do
        def image_tag(url, options = {})
          url, options = extensions[:images].image(url, options)
          super
        end

        def image_path(source, options = {})
          super(source)
        end

        def image_url(source, options = {})
          super(source)
        end
      end

      def template_context
        @template_context ||= app.template_context_class.new(app, {}, {})
      end

      def process(url, process_options)
        source = app.sitemap.find_resource_by_path(url)
        destination_path(source, process_options).tap do |url|
          unless app.sitemap.find_resource_by_path(url)
            image = Image.new(@app, source.source_file, url, process_options)
            app.sitemap.register_resource_list_manipulator(:images, image, 40)
            app.sitemap.rebuild_resource_list!(:images)
          end
        end
      end

      def image(url, options)
        image_options = options.except(:resize, :optimize)
        process_options = {
          resize: options[:resize],
          optimize: options.key?(:optimize) ? options[:optimize] : self.options[:optimize],
          image_optim: self.options[:image_optim]
        }
        if process_options[:resize] || process_options[:optimize]
          url = process(url, process_options)
        end
        [url, image_options]
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
    end
  end
end
