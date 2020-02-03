require 'image_optim'

module Middleman
  module Images
    class Image
      attr_reader :destination, :source

      def initialize(app, source, destination, options = {})
        @app = app
        @source = source
        @destination = destination
        @options = options
        @cache = File.join(app.root, 'cache', destination).to_s
        FileUtils.mkdir_p File.dirname(cache)
      end

      def process
        return if File.exist?(cache) && File.mtime(source) < File.mtime(cache)

        app.logger.info "== Images: Processing #{destination}"
        FileUtils.copy(source, cache)
        resize(cache, options[:resize]) unless options[:resize].nil?
        optimize(cache, options[:image_optim]) if options[:optimize]
      end

      def resource
        @resource ||= ::Middleman::Sitemap::Resource.new(app.sitemap, destination, cache)
      end

      private

      def resize(image_path, options)
        begin
          require "mini_magick"
        rescue LoadError
          raise 'The gem "mini_magick" is required for image resizing. Please install "mini_magick" or remove the resize option.'
        end

        image = MiniMagick::Image.new(image_path) do |i|
          i.resize(options)
          i.define('jpeg:preserve-settings')
        end
        image.write image_path
      end

      def optimize(image_path, options)
        ImageOptim.new(options).optimize_image!(image_path)
      end

      attr_accessor :app, :cache, :options
    end
  end
end
