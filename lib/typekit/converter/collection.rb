module Typekit
  module Converter
    class Collection
      def initialize(*arguments)
        @arguments = arguments
      end

      def process(result, collection_attributes)
        collection_attributes = collection_attributes.map do |attributes|
          attributes.is_a?(Hash) ? attributes : { id: attributes }
        end
        Typekit::Collection.build(*@arguments, collection_attributes)
      end
    end
  end
end
