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
        tmp = File.join(@app.root, 'tmp', destination).to_s
        FileUtils.mkdir_p File.dirname(tmp)
        if !File.exist?(tmp) || File.mtime(source) > File.mtime(tmp)
          process_image(source, tmp, options)
        end
        ::Middleman::Sitemap::Resource.new(@app.sitemap, destination, tmp)
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
