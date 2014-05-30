module Typekit
  module Processing
    module Converter
      class Variation
        def process(response, attributes)
          Record::Variation.new(attributes)
        end
      end
    end
  end
end
