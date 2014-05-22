module Typekit
  module Routing
    class Mapper
      def initialize(map, scope: [])
        @map = map
        @scope = scope
      end

      def resources name, &block
        @map.define_resources name, scope: @scope, &block
      end
    end
  end
end
