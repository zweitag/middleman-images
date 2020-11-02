require "middleman-core"
require "pathname"
require "padrino-helpers"
require_relative "image"

module Middleman
  module Images
    class Extension < ::Middleman::Extension
      option :optimize, false, "Whether to optimize images by default"
      option :image_optim, {}, "Default options for image_optim"
      option :ignore_original, false, "Whether to ignore original images in build"
      option :cache_dir, "cache", "Specification of cache folder"
      OPTION_NAMES = (Middleman::Images::Image::MINI_MAGICK_OPTIONS + %i[optimize]).freeze
      HASH_SIZE = 40

      helpers do
        def image_tag(path, options = {})
          process_options = options.slice(*OPTION_NAMES)
          options = { src: image_path(path, process_options) }.update(options.except(*OPTION_NAMES))
          super(path, options)
        end

        def image_path(path, process_options = {})
          path = extensions[:images].image_path(path, process_options)
          super(path)
        end
      end

      def manipulate_resource_list(resources)
        @manipulator.manipulate_resource_list(resources)
      end

      def image_path(path, process_options)
        source = app.sitemap.find_resource_by_path(absolute_path(path))
        return path if source.nil?

        process_options[:image_optim] = options[:image_optim]
        process_options[:optimize] = options[:optimize] unless process_options.key?(:optimize)

        if process_options.slice(*OPTION_NAMES).any?
          processed_path = Pathname.new(add_processed_resource(source, process_options))
          images_dir = Pathname.new(app.config[:images_dir])
          path = processed_path.relative_path_from(Pathname.new(app.config[:images_dir])).to_s
        else
          @manipulator.preserve_original source
        end

        path
      end

      def initialize(app, options_hash = {}, &block)
        super
        @manipulator = Manipulator.new(@app, options[:ignore_original])
      end

      private

      def absolute_path(path)
        absolute_path = path.start_with?("/") || path.start_with?(app.config[:images_dir])
        absolute_path ? path : app.config[:images_dir] + "/" + path
      end

      def add_processed_resource(source, process_options)
        build_processed_path(source, process_options).tap do |processed_path|
          processed_resource = Image.new(app.sitemap, processed_path, source.source_file, process_options.merge(cache_dir: options[:cache_dir]))
          @manipulator.add(processed_resource)
        end
      end

      def build_processed_path(source, process_options)
        destination = source.normalized_path.sub(/#{source.ext}$/, "")

        options_part = process_options.slice(*Middleman::Images::Image::MINI_MAGICK_OPTIONS).keys
                                                                                            .sort
                                                                                            .map do |option_name|
          CGI.escape(process_options[option_name].to_s.gsub(/\W+/, '_'))
        end
        options_part << 'opt' if process_options[:optimize]
        options_part = options_part.join('-')
        options_part = Digest::SHA1.hexdigest(options_part) if options_part.size > HASH_SIZE
        destination += "-#{options_part}" if options_part.size > 0

        destination + source.ext
      end
    end
  end
end
