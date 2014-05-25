module Typekit
  module Routing
    class Collection < Node
      def initialize(name, only: nil)
        @name = name
        @actions = only && Array(only) || Config.actions
        unless (@actions - Config.actions).empty?
          raise RoutingError, 'Not supported'
        end
      end

      def match(name)
        @name == name
      end

      def process(request, path)
        request << path.shift # @name
        return request if path.empty?
        request << path.shift
      end

      def permitted?(request)
        @actions.include?(request.action)
      end
    end
  end
end
