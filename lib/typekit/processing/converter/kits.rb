module Typekit
  module Processing
    module Converter
      class Kits
        def process(response, attributes_collection)
          attributes_collection.map do |attributes|
            Record::Kit.new(attributes)
          end
        end
      end
    end
  end
end
