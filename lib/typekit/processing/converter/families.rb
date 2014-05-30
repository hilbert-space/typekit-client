module Typekit
  module Processing
    module Converter
      class Families
        def process(response, attributes_collection)
          attributes_collection.map do |attributes|
            Record::Family.new(attributes)
          end
        end
      end
    end
  end
end
