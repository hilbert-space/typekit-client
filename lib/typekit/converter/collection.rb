module Typekit
  module Converter
    class Collection
      def initialize(*arguments)
        @arguments = arguments
      end

      def process(result, collection_attributes)
        Typekit::Collection.build(*@arguments, collection_attributes)
      end
    end
  end
end
