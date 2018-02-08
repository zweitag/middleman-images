module Middleman
  module Images
    class Manipulator
      def initialize(app)
        @app = app
        @images = []
      end

      def add(image)
        images << image
      end

      def manipulate_resource_list(resources)
        images.each(&:process)
        resources += images.collect(&:resource)
      end

      private

      attr_accessor :app, :images
    end
  end
end
