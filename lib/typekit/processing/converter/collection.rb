module Typekit
  module Processing
    module Converter
      class Collection
        def initialize(name)
          @name = name
        end

        def process(result, collection_attributes)
          collection_attributes = collection_attributes.map do |attributes|
            attributes.is_a?(Hash) ? attributes : { id: attributes }
          end
          Typekit::Collection.build(@name, collection_attributes)
        end
      end
    end
  end
end
