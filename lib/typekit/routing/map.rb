module Typekit
  module Routing
    class Map
      def initialize
        @collections = {}
      end

      def define_collection(collection, scope: [], &block)
        path = [ *Array(scope), collection ]
        path.inject(@collections) { |h, k| h[k] ||= {} }
        if block_given?
          mapper = Mapper.new(self, scope: path)
          mapper.instance_eval(&block)
        end
      end

      def collections
        # TODO: find a better way of deep cloning?
        Marshal.load(Marshal.dump(@collections))
      end

      def define(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
      end
    end
  end
end
