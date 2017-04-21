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
        @app.logger.info "== Middleman Images: Processing #{@destination}"
        resources << build_resource(@source, @destination, @options)
      end

      private

      def build_resource(source, destination, options)
        destination_full = (@app.source_dir + destination).to_s
        process_image(source, destination_full, options)
        ::Middleman::Sitemap::Resource.new(@app.sitemap, destination, destination_full)
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
