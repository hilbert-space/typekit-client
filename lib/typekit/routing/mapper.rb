module Typekit
  module Routing
    class Mapper
      def initialize(map, scope: [])
        @map = map
        @scope = scope
      end

      def collection(name, &block)
        @map.define_collection(name, scope: @scope, &block)
      end
    end
  end
end
