module Middleman
  module Images
    class Manipulator
      def initialize(app, ignore_original)
        @app = app
        @images = []
        @required_originals = []
        @ignore_original = ignore_original
        @inspected_at = {}
        @destination_paths = []
      end

      def add(image)
        images << image unless @destination_paths.include?(image.destination_path)
        @destination_paths << image.destination_path
      end

      def preserve_original(resource)
        required_originals << resource.source_file
      end

      def manipulate_resource_list(resources)
        app.logger.info "== Images: Registering images to process. This may take a while…"

        resources.each do |resource|
          next unless inspect?(resource)

          app.logger.debug "== Images: Inspecting #{resource.destination_path} for images to process."

          @inspected_at[resource.source_file] = File.mtime(resource.source_file)
          begin
            # We inspect templates by triggering the render method on them. This way our
            # image_tag and image_path helpers will get called and register the images.
            resource.render({}, {})
          rescue => e
            app.logger.debug e
            app.logger.debug "== Images: There was an error inspecting #{resource.destination_path}. Images for this resource will not be processed."
          end
        end

        app.logger.info "== Images: All images have been registered."

        ignore_orginal_resources(resources) if ignore_original
        resources + images
      end

      private

      attr_accessor :app, :images, :ignore_original, :required_originals

      def inspect?(resource)
        return false unless resource.template?

        inspected_at = @inspected_at[resource.source_file]
        return true if inspected_at.nil?

        inspected_at < File.mtime(resource.source_file)
      end

      def ignore_orginal_resources(resources)
        originals = images.map(&:source)
        unused_originals = originals - required_originals

        resources.each do |resource|
          if unused_originals.include? resource.source_file
            resource.ignore!
          elsif required_originals.include? resource.source_file
            resource.ignored = false
          end
        end
      end
    end
  end
end
