require 'forwardable'

module Typekit
  module Routing
    class Map
      extend Forwardable

      def_delegator :@root, :assemble, :trace

      def initialize(&block)
        @root = Node::Root.new
        define(&block) if block_given?
      end

      def define(&block)
        proxy = Proxy.new(self)
        proxy.instance_eval(&block)
      end

      def define_scope(path, parent: @root, &block)
        child = Node::Scope.new(path)
        parent.append(child)
        proxy = Proxy.new(self, parent: child)
        proxy.instance_eval(&block)
      end

      def define_resources(name, parent: @root, **options, &block)
        child = Node::Collection.new(name, **options)
        parent.append(child)
        return unless block_given?
        proxy = Proxy.new(self, parent: child)
        proxy.instance_eval(&block)
      end

      Typekit.actions.each do |action|
        define_method "define_#{ action }" do |name, parent:, **options|
          child = Node::Operation.new(name, action: action, **options)
          parent.append(child)
        end
      end
    end
  end
end
