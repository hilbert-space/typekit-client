module Typekit
  module Processing
    module Converter
      class Boolean
        def initialize(*)
        end

        def process(response, object)
          object # already boolean
        end
      end
    end
  end
end
