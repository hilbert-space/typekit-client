module Typekit
  module Processing
    module Converter
      class Family
        def process(response, attributes)
          Record::Family.new(attributes)
        end
      end
    end
  end
end
