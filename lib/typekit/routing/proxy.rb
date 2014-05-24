module Typekit
  module Routing
    class Proxy
      def initialize(map, **options)
        @map = map
        @options = options
      end

      def resources(name, **options, &block)
        @map.define_collection(name, **@options, **options, &block)
      end
    end
  end
end
