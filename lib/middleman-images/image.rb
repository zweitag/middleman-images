module Middleman
  module Images
    class Image < Middleman::Sitemap::Resource
      attr_reader :destination, :source

      IGNORE_RESIZING = {
        ".svg" =>  "WARNING: We did not resize %{file}. Resizing SVG files will lead to ImageMagick creating an SVG with an embedded binary image thus making the file way bigger.",
        ".gif" =>  "WARNING: We did not resize %{file}. Resizing GIF files will remove the animation. If your GIF file is not animated, use JPG or PNG instead.",
      }.freeze

      def initialize(app, source, destination, options = {})
        @app = app
        @source = source
        @destination = destination
        @options = options
        @cache = File.join(app.root, options[:cache_dir], destination).to_s
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

      # We want to process images as late as possible. Before Middleman works with our source file, it will check
      # whether it is binary? or static_file?. That's when we need to ensure the processed source files exist.
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

        image_ext = File.extname(image_path)
        if IGNORE_RESIZING.keys.include? image_ext
          app.logger.warn("== Images: " + (IGNORE_RESIZING[image_ext] % { file: image_path }))
          return
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
