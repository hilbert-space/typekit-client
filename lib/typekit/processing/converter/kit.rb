module Typekit
  module Processing
    module Converter
      class Kit
        def process(response, attributes)
          Record::Kit.new(attributes)
        end
      end
    end
  end
end
