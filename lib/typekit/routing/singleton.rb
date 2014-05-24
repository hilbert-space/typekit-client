module Typekit
  module Routing
    class Singleton < Node
      def initialize(name, action:, on:, **options)
        raise RoutingError, 'Not supported' unless on == :member # dummy
        super(name, only: action, **options)
      end

      def assemble(request)
        @scope.each { |chunk| request << chunk }
        request << @name unless dummy?
        authorize(request)
      end
    end
  end
end
