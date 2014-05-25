module Typekit
  module Routing
    module Node
      class Singleton < Base
        def initialize(name, action:, on:, **options)
          unless Config.actions.include?(action) && on == :member # dummy
            raise RoutingError, 'Not supported'
          end
          @name = name
          @action = action
        end

        def match(name)
          if @name.is_a?(String) && @name =~ /^:/
            true
          else
            @name == name
          end
        end

        def process(request, path)
          request << path.shift # @name
        end

        def permitted?(request)
          @action == request.action
        end
      end
    end
  end
end
