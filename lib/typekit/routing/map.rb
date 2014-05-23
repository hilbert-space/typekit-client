module Typekit
  module Routing
    class Map
      def initialize
        @resources = {}
      end

      def define_resources(name, scope: [], &block)
        path = [ *Array(scope), name ]
        path.inject(@resources) { |h, k| h[k] ||= {} }
        return unless block_given?
        mapper = Mapper.new(self, scope: path)
        mapper.instance_eval(&block)
      end

      def resources
        # TODO: find a better way of deep cloning?
        Marshal.load(Marshal.dump(@resources))
      end

      def draw(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
      end
    end
  end
end
