module Typekit
  module Routing
    class Collection
      ACTIONS = [ :index, :show, :update, :delete ]

      attr_reader :name

      def initialize(name = nil, only: nil)
        @name = name
        @actions = only && Array(only) || ACTIONS

        @parent = nil
        @children = {}
      end

      def append(child)
        child.prepend(self)
        @children[child.name] = child
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

      def assemble(request, *path)
        request << @name unless dummy?
        return authorize(request) if path.empty?
        request << path.shift unless dummy?
        return authorize(request) if path.empty?
        find_child(path.shift).assemble(request, *path)
      end

      protected

      def dummy?
        @name.nil?
      end

      def root?
        @parent.nil?
      end

      def prepend(parent)
        @parent = parent
      end

      def find_child(name)
        @children[name] or raise RoutingError, 'Not found'
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
