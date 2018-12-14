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
        @cache = File.join(app.root, 'cache', destination).to_s
        FileUtils.mkdir_p File.dirname(cache)
      end

      def process
        if !File.exist?(cache) || File.mtime(source) > File.mtime(cache)
          app.logger.info "== Images: Processing #{destination}"
          resize(source, cache, options[:resize]) unless options[:resize].nil?
          optimize(cache, options[:image_optim]) if options[:optimize]
        end
      end

      def resource
        @resource ||= ::Middleman::Sitemap::Resource.new(app.sitemap, destination, cache)
      end

      private

      def resize(source, cache, options)
        image = MiniMagick::Image.open(source)
        image.resize(options)
        image.write cache
      end

      def optimize(cache, options)
        ImageOptim.new(options).optimize_image!(cache)
      end

      attr_accessor :app, :cache, :options
    end
  end
end
