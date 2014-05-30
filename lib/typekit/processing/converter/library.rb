module Typekit
  module Processing
    module Converter
      class Library
        def process(response, attributes)
          Record::Library.new(attributes)
        end
      end
    end
  end
end
