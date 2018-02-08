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
        @cache = File.join(app.root, 'cache', destination).to_s
        FileUtils.mkdir_p File.dirname(cache)
      end

      def process
        if !File.exist?(cache) || File.mtime(source) > File.mtime(cache)
          app.logger.info "== Images: Processing #{destination}"
          image = MiniMagick::Image.open(source)
          image.resize options[:resize] unless options[:resize].nil?
          ImageOptim.new(options[:image_optim]).optimize_image!(image.path) if options[:optimize]
          image.write cache
        end
      end

      def resource
        @resource ||= ::Middleman::Sitemap::Resource.new(app.sitemap, destination, cache)
      end

      private

      attr_accessor :app, :cache, :destination, :source, :options
    end
  end
end
