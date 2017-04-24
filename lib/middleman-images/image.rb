require 'mini_magick'
require 'image_optim'

module Middleman
  module Images
    class Image

      def initialize(app, source, destination, options = {})
        @app = app
        @source = source
        @destination = destination
        @options = options
      end

      def manipulate_resource_list(resources)
        resources << build_resource(@source, @destination, @options)
      end

      private

      def build_resource(source, destination, options)
        cache = File.join(@app.root, 'cache', destination).to_s
        FileUtils.mkdir_p File.dirname(cache)
        if !File.exist?(cache) || File.mtime(source) > File.mtime(cache)
          process_image(source, cache, options)
        end
        ::Middleman::Sitemap::Resource.new(@app.sitemap, destination, cache)
      end

      def process_image(source, destination, options)
        image = MiniMagick::Image.open(source)
        image.resize options[:resize] unless options[:resize].nil?
        ImageOptim.new(options[:image_optim]).optimize_image!(image.path) if options[:optimize]
        image.write destination
      end
    end
  end
end
