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
        return if File.exist?(cache) && File.mtime(source) < File.mtime(cache)

        app.logger.info "== Images: Processing #{destination}"
        FileUtils.copy(source, cache)

        unless options[:resize].nil?
          if %w[.svg .gif].include?(File.extname(source))
            app.logger.warn <<~WARN.strip.tr("\n", ' ')
              WARNING: The file #{source} being resized is an SVG or a GIF.
              ImageMagick builds a new binary as base64.
              Please remove the resize option.
            WARN
          end

          resize(cache, options[:resize]) unless options[:resize].nil?
        end

        optimize(cache, options[:image_optim]) if options[:optimize]
      end

      def resource
        @resource ||= ::Middleman::Sitemap::Resource.new(app.sitemap, destination, cache)
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
