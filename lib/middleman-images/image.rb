require 'mini_magick'
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
        @cache = File.join(app.root, options[:cache_dir], destination).to_s
        FileUtils.mkdir_p File.dirname(cache)
      end

      def process
        if !File.exist?(cache) || File.mtime(source) > File.mtime(cache)
          app.logger.info "== Images: Processing #{destination}"
          image = MiniMagick::Image.open(source)
          resize(image, options[:resize]) unless options[:resize].nil?
          optimize(image.path, options[:image_optim]) if options[:optimize]
          image.write cache
        end
      end

      def resource
        @resource ||= ::Middleman::Sitemap::Resource.new(app.sitemap, destination, cache)
      end

      private

      def resize(image, options)
        image.combine_options do |i|
          i.resize(options)
          i.define('jpeg:preserve-settings')
        end
      end

      def optimize(image_path, options)
        ImageOptim.new(options).optimize_image!(image_path)
      end

      attr_accessor :app, :cache, :options
    end
  end
end
