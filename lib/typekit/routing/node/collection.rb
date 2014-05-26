module Typekit
  module Routing
    module Node
      class Collection < Base
        def initialize(name, only: nil)
          @name = name
          @actions = only && Array(only) || Typekit.actions
          unless (@actions - Typekit.actions).empty?
            raise Error, 'Not supported'
          end
        end

        def match(name)
          @name == name
        end

        def process(request, path)
          request << path.shift # @name
          return request if path.empty?
          request << path.shift # id
        end

        def permitted?(request)
          return false unless @actions.include?(request.action)

          id_present = request.path.last != @name
          member_action = Helper.member_action?(request.action)

          id_present == member_action
        end
      end
    end
  end
end
