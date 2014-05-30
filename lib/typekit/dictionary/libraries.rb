module Typekit
  module Dictionary
    class Libraries
      def process(response, attributes_collection)
        attributes_collection.map do |attributes|
          Record::Library.new(attributes)
        end
      end
    end
  end
end
