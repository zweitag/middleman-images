module Middleman
  module Images
    class Image

      def initialize(app, source, destination)
        @sitemap = app.sitemap
        @source = source
        @destination = destination
      end

      def manipulate_resource_list(resources)
        return resources if @sitemap.find_resource_by_path(@destination)
        resources << build_resource(@source, @destination)
      end

      private

      def build_resource(source, destination)
        Sitemap::ProxyResource.new(@sitemap, destination, source).tap do |p|
          p.add_metadata locals: {
            "source"       => source,
            "destination"        => destination
          }
        end
      end
    end
  end
end
