module Middleman
  module Images
    class Image < Middleman::Sitemap::Resource
      attr_reader :destination, :source

      def initialize(app, source, destination, options = {})
        @app = app
        @source = source
        @destination = destination
        @options = options
        @cache = File.join(app.root, 'cache', destination).to_s
        FileUtils.mkdir_p File.dirname(cache)

        super(app.sitemap, destination, cache)
      end

      def process
        return if File.exist?(cache) && File.mtime(source) < File.mtime(cache)

        app.logger.info "== Images: Processing #{destination}"

        FileUtils.copy(source, cache)
        resize(cache, options[:resize]) unless options[:resize].nil?
        optimize(cache, options[:image_optim]) if options[:optimize]
      end

      def binary?
        process
        super
      end

      def static_file?
        process
        super
      end

      private

      def resize(image_path, options)
        begin
          require 'mini_magick'
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
        begin
          require 'image_optim'
        rescue LoadError
          raise "The gem 'image_option' is required for image optimization. Please install the gem 'image_optim' or set the option optimize: false."
        end

        ImageOptim.new(options).optimize_image!(image_path)
      end

      attr_accessor :app, :cache, :options
    end
  end
end
