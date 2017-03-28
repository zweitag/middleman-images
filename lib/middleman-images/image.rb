require 'mini_magick'

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
        resize_image(source, destination_full, options[:resize]) # TODO: Add condition, but copy file in any case
        ::Middleman::Sitemap::Resource.new(@app.sitemap, destination, destination_full)
      end

      def resize_image(source, destination, dimensions)
        image = MiniMagick::Image.open(source)
        image.resize dimensions unless dimensions.nil?
        image.write destination
      end
    end
  end
end
