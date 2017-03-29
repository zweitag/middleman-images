require 'middleman-core'
require 'pathname'

module Middleman
  module Images
    class Extension < ::Middleman::Extension

      helpers do
        def image_tag(url, options = {})
          if options[:resize] || options[:optimize]
            extensions[:images].resize_image(url, options)
          else
            super
          end
        end
      end

      def template_context
        @template_context ||= app.template_context_class.new(app, {}, {})
      end

      def resize_image(url, options)
        resize = options.delete(:resize)
        optimize = !! options.delete(:optimize)
        delete_original = !! options.delete(:delete_original) # TODO call resource.ignore!
        options = {alt: template_context.image_alt(url)}.merge(options) # TODO: also 'alt'
        source = app.sitemap.find_resource_by_path(url)
        destination = source.normalized_path.sub(/#{source.ext}$/, '') + '-' + template_context.escape_html(resize) + source.ext
        # FIXME https://github.com/toy/image_optim, guetzli, etc.
        # TODO copy alt tag to exif data
        image = Image.new(@app, source.source_file, destination, { resize: resize })
        app.sitemap.register_resource_list_manipulator(:images, image, 40)
        app.sitemap.rebuild_resource_list!(:images)
        template_context.image_tag(destination, options)
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
    end
  end
end
