module Typekit
  module Processing
    module Converter
      class Collection
        def initialize(name)
          @klass = Typekit::Record.classify(name)
          raise Error, 'Unknown class' unless @klass
        end

        def process(response, collection_attributes)
          collection_attributes.map do |attributes|
            @klass.new(attributes)
          end
        end
      end
    end
  end
end
