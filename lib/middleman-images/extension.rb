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
          options = extensions[:images].store_process_options(options)
          super
        end

        def image_path(url, process_options = {})
          url = extensions[:images].process(url, process_options)
          super(url)
        end
      end

      def template_context
        @template_context ||= app.template_context_class.new(app, {}, {})
      end

      def process(url, process_options)
        process_options = self.reset_process_options.merge(process_options)
        if process_options[:resize] || process_options[:optimize]
          source = app.sitemap.find_resource_by_path(url)
          destination_path(source, process_options).tap do |url|
            unless app.sitemap.find_resource_by_path(url)
              image = Image.new(@app, source.source_file, url, process_options)
              app.sitemap.register_resource_list_manipulator(:images, image, 40)
              app.sitemap.rebuild_resource_list!(:images)
            end
          end
        else
          url
        end
      end

      def store_process_options(options)
        @process_options[:resize] = options.delete(:resize) if options.has_key?(:resize)
        @process_options[:optimize] = options.delete(:optimize) if options.has_key?(:optimize)
        options
      end

      def reset_process_options
        po = @process_options
        @process_options = self.options.to_h
        po
      end

      def initialize(app, options_hash={}, &block)
        super
        reset_process_options
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
