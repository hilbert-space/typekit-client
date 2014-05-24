module Typekit
  module Routing
    class Map
      attr_reader :collections

      def initialize &block
        @collections = {}
        define(&block) if block_given?
      end

      def define_collection(collection, scope: [], &block)
        path = [ *Array(scope), collection ]
        path.inject(@collections) { |h, k| h[k] ||= {} }
        if block_given?
          mapper = Mapper.new(self, scope: path)
          mapper.instance_eval(&block)
        end
      end

      def define(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
      end
    end
  end
end
