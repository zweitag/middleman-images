module Middleman
  module Images
    class Manipulator
      def initialize(app, ignore_original)
        @app = app
        @images = []
        @required_originals = []
        @ignore_original = ignore_original
      end

      def add(image)
        unless images.collect(&:destination).include? image.destination
          images << image
        end
      end

      def preserve_original(source)
        required_originals << source
      end

      def manipulate_resource_list(resources)
        ignore_orginal_resources(resources) if ignore_original
        resources + processed_images
      end

      private

      attr_accessor :app, :images, :ignore_original, :required_originals

      def processed_images
        images.each(&:process)
        images.collect(&:resource)
      end

      def ignore_orginal_resources(resources)
        originals = images.map(&:source)
        unused_originals = originals - required_originals

        resources.each do |resource|
          if unused_originals.include? resource
            resource.source_file.ignore!
          elsif required_originals.include? resource
            resource.source_file.ignored = false
          end
        end
      end
    end
  end
end
