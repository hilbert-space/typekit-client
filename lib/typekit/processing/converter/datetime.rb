module Typekit
  module Processing
    module Converter
      class DateTime
        def initialize(*)
        end

        def process(response, object)
          ::DateTime.parse(object)
        end
      end
    end
  end
end
