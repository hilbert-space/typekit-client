module Typekit
  module Routing
    class Map
      def initialize(&block)
        @root = Node::Root.new
        define(&block) if block_given?
      end

      def define(&block)
        proxy = Proxy.new(self)
        proxy.instance_eval(&block)
      end

      def request(action, *path)
        @root.assemble(Request.new(action: action), *path)
      end

      def define_collection(name, parent: @root, **options, &block)
        child = Node::Collection.new(name, **options)
        parent.append(child)
        return unless block_given?
        proxy = Proxy.new(self, parent: child)
        proxy.instance_eval(&block)
      end

      def define_singleton(action, name, parent:, **options)
        child = Node::Singleton.new(name, action: action, **options)
        parent.append(child)
      end

      def define_scope(path, parent: @root, &block)
        child = Node::Scope.new(path)
        parent.append(child)
        proxy = Proxy.new(self, parent: child)
        proxy.instance_eval(&block)
      end
    end
  end
end
