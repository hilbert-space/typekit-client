require_relative 'collection'
require_relative 'proxy'

module Typekit
  module Routing
    class Map
      def initialize(&block)
        @root = Collection.new
        define(&block) if block_given?
      end

      def define(&block)
        proxy = Proxy.new(self)
        proxy.instance_eval(&block)
      end

      def request(action, *trace)
        @root.assemble(Request.new(action: action), *trace)
      end

      def define_collection(name, path: [], **options, &block)
        child = Collection.new(name, **options)
        @root.find(*path).append(child)
        if block_given?
          proxy = Proxy.new(self, path: child.trace)
          proxy.instance_eval(&block)
        end
      end
    end
  end
end
