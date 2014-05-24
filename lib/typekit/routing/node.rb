module Typekit
  module Routing
    class Node
      ACTIONS = [ :index, :show, :update, :delete ]

      attr_accessor :name

      def initialize(name = nil, only: nil, scope: [])
        @name = name
        @actions = only && Array(only) || ACTIONS
        @scope = Array(scope)

        @parent = nil
        @children = {}
      end

      def append(child)
        @children[child.name] = child
        child.prepend(self)
      end

      def find(*path)
        return self if path.empty?
        find_child(path.shift).find(*path)
      end

      def trace(path = [])
        path.unshift(@name) unless dummy?
        return path if root?
        @parent.trace(path)
      end

      def assemble
      end

      protected

      def dummy?
        @name.nil?
      end

      def root?
        @parent.nil?
      end

      def find_child(name)
        @children[name] or raise RoutingError, 'Not found'
      end

      def prepend(parent)
        @parent = parent
      end

      def authorize(request)
        raise RoutingError, 'Not permitted' unless permitted?(request.action)
        request
      end

      def permitted?(action)
        @actions.include?(action)
      end
    end
  end
end
