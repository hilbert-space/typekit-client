module Typekit
  module Processing
    module Converter
      class DateTime
        def initialize(*_)
        end

        def process(response, object)
          ::DateTime.parse(object)
        end
      end
    end
  end
end
