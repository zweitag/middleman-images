module Middleman
  module Images
    class Image < Middleman::Sitemap::Resource
      IGNORE_ACTION = {
        resize: {
          ".svg" => "WARNING: We did not resize %{file}. Resizing SVG files will lead to ImageMagick creating an SVG with an embedded binary image thus making the file way bigger.",
          ".gif" => "WARNING: We did not resize %{file}. Resizing GIF files will remove the animation. If your GIF file is not animated, use JPG or PNG instead.",
        },
        crop: {
          ".svg" => "WARNING: We did not crop %{file}. Cropping SVG files will lead to ImageMagick creating an SVG with an embedded binary image thus making the file way bigger.",
          ".gif" => "WARNING: We did not crop %{file}. Cropping GIF files will remove the animation. If your GIF file is not animated, use JPG or PNG instead.",
        }
      }.freeze
      MINI_MAGICK_OPTIONS = %i[adaptive-blur adaptive-resize adaptive-sharpen adjoin affine alpha annotate antialias
                               append attenuate authenticate auto-gamma auto-level auto-orient auto-threshold backdrop
                               background bench bias black-point-compensation black-threshold blend blue-primary
                               blue-shift blur border bordercolor borderwidth brightness-contrast cache canny caption
                               cdl channel charcoal channel-fx chop clahe clamp clip clip-mask clip-path clone clut
                               coalesce colorize colormap color-matrix colors colorspace color-threshold combine comment
                               compare complex compose composite compress connected-components contrast contrast-stretch
                               convolve copy crop cycle debug decipher deconstruct define delay delete density depth
                               descend deskew despeckle direction displace display dispose dissimilarity-threshold
                               dissolve distort distribute-cache dither draw duplicate edge emboss encipher encoding
                               endian enhance equalize evaluate evaluate-sequence extent extract family features fft
                               fill filter flatten flip floodfill flop font foreground format frame function fuzz fx
                               gamma gaussian-blur geometry gravity grayscale green-primary hald-clut highlight-color
                               hough-lines iconGeometry iconic identify ift immutable implode insert intensity intent
                               interlace interpolate interline-spacing interword-spacing kerning kmeans kuwahara label
                               lat layers level level-colors limit linear-stretch linewidth liquid-rescale list log loop
                               lowlight-color magnify map mattecolor median mean-shift metric mode modulate moments
                               monitor monochrome morph morphology mosaic motion-blur name negate noise normalize opaque
                               ordered-dither orient page paint path perceptible ping pointsize polaroid poly posterize
                               precision preview print process profile quality quantize quiet radial-blur raise
                               random-threshold range-threshold read-mask red-primary regard-warnings region remap
                               remote render repage resample resize respect-parentheses reverse roll rotate sample
                               sampling-factor scale scene screen seed segment selective-blur separate sepia-tone set
                               shade shadow shared-memory sharpen shave shear sigmoidal-contrast silent
                               similarity-threshold size sketch smush snaps solarize sparse-color splice spread
                               statistic stegano stereo storage-type stretch strip stroke strokewidth style
                               subimage-search swap swirl synchronize taint text-font texture threshold thumbnail tile
                               tile-offset tint title transform transparent transparent-color transpose transverse
                               treedepth trim type undercolor unique-colors units unsharp update verbose version view
                               vignette virtual-pixel visual watermark wave wavelet-denoise weight white-balance
                               white-point white-threshold window window-group write write-mask].freeze


      attr_reader :app, :original_source_file

      def initialize(store, path, source, options = {})
        @original_source_file = source

        processed_source_file = File.join(store.app.root, options.delete(:cache_dir), path)
        FileUtils.mkdir_p File.dirname(processed_source_file)

        @processing_options = options

        super(store, path, processed_source_file)
      end

      def process
        return if File.exist?(processed_source_file) && File.mtime(original_source_file) < File.mtime(processed_source_file)

        app.logger.info "== Images: Processing #{@path}"

        FileUtils.copy(original_source_file, processed_source_file)
        run_mini_magick = MINI_MAGICK_OPTIONS.find { |o| @processing_options.key?(o) }

        mini_magick(processed_source_file, @processing_options) if run_mini_magick
        optimize(processed_source_file, @processing_options[:image_optim]) if @processing_options[:optimize]
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

      # The processed source file is the new source file for middleman.
      def processed_source_file
        source_file
      end

      private

      def mini_magick(image_path, options)
        h = {}
        mini_magick_options = options.slice(*MINI_MAGICK_OPTIONS)
        ensure_mini_magick_installed(mini_magick_options.keys)

        image = MiniMagick::Image.new(image_path) do |i|
          mini_magick_options.each_pair do |action, args|
            i.public_send(action, args) unless ignore_action?(image_path, action)
          end
          i.define("jpeg:preserve-settings")
        end
        image.write image_path
      end

      def optimize(image_path, options)
        begin
          require "image_optim"
        rescue LoadError
          raise "The gem 'image_option' is required for image optimization. Please install the gem 'image_optim' or set the option optimize: false."
        end

        ImageOptim.new(options).optimize_image!(image_path)
      end

      def ensure_mini_magick_installed(actions)
        begin
          require "mini_magick"
        rescue LoadError
          raise "The gem 'mini_magick' is required for image resizing. Please install 'mini_magick' or remove the " \
                "option(s) #{actions.map(&:to_s).join(', ')}."
        end
      end

      def ignore_action?(image_path, action)
        image_ext = File.extname(image_path)
        return false unless IGNORE_ACTION[action]&.keys&.include?(image_ext)

        app.logger.warn("== Images: " + (IGNORE_ACTION[action][image_ext] % { file: image_path }))
        true
      end
    end
  end
end
