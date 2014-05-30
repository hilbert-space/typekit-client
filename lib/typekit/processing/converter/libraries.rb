module Typekit
  module Processing
    module Converter
      class Libraries
        def process(response, attributes_collection)
          attributes_collection.map do |attributes|
            Record::Library.new(attributes)
          end
        end
      end
    end
  end
end
