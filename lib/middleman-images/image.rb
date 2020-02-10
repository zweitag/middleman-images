module Middleman
  module Images
    class Image < Middleman::Sitemap::Resource
      IGNORE_RESIZING = {
        ".svg" =>  "WARNING: We did not resize %{file}. Resizing SVG files will lead to ImageMagick creating an SVG with an embedded binary image thus making the file way bigger.",
        ".gif" =>  "WARNING: We did not resize %{file}. Resizing GIF files will remove the animation. If your GIF file is not animated, use JPG or PNG instead.",
      }.freeze

      attr_reader :app, :original_source_file

      def initialize(store, path, source, options = {})
        @original_source_file = source

        cache = File.join(store.app.root, options.delete(:cache_dir), path).to_s
        FileUtils.mkdir_p File.dirname(cache)

        @processing_options = options

        super(store, path, cache)
      end

      def process
        return if File.exist?(source_file) && File.mtime(original_source_file) < File.mtime(source_file)

        app.logger.info "== Images: Processing #{@path}"

        FileUtils.copy(original_source_file, source_file)
        resize(source_file, @processing_options[:resize]) unless @processing_options[:resize].nil?
        optimize(source_file, @processing_options[:image_optim]) if @processing_options[:optimize]
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
    end
  end
end
