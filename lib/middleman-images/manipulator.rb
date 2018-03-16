module Middleman
  module Images
    class Manipulator
      def initialize(app, ignore_original)
        @app = app
        @images = []
        @ignore_original = ignore_original
      end

      def add(image)
        unless images.collect(&:destination).include? image.destination
          images << image
        end
      end

      def manipulate_resource_list(resources)
        resources = remove_original_images(resources) if ignore_original
        resources + processed_images
      end

      private

      attr_accessor :app, :images, :ignore_original

      def processed_images
        images.each(&:process)
        images.collect(&:resource)
      end

      def remove_original_images(resources)
        resources.reject do |resource|
          images.map(&:source).include? resource.source_file
        end
      end
    end
  end
end
