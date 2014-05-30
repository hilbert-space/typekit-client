module Typekit
  module Dictionary
    class Kits
      def process(response, attributes_collection)
        attributes_collection.map do |attributes|
          Record::Kit.new(attributes)
        end
      end
    end
  end
end
