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
        return resources if @app.sitemap.find_resource_by_path(@destination)
        resources << build_resource(@source, @destination, @options)
      end

      private

      def build_resource(source, destination, options)
        destination_full = (@app.source_dir + destination).to_s
        resize_image(source, destination_full, options) # TODO: Add condition, but copy file in any case
        ::Middleman::Sitemap::Resource.new(@app.sitemap, destination, destination_full)
      end

      def resize_image(source, destination, options)
        image = MiniMagick::Image.open(source)
        image.resize options[:resize] unless options[:resize].nil?
        ImageOptim.new(options[:image_optim]).optimize_image!(image.path) if options[:optimize]
        image.write destination
      end
    end
  end
end
