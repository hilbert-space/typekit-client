module Typekit
  module Processing
    module Converter
      class DateTime
        def process(response, object)
          ::DateTime.parse(object)
        end
      end
    end
  end
end