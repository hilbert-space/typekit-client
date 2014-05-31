module Typekit
  module Processing
    module Converter
      class Records
        def initialize(name)
          name = Helper.singularize(name.to_s).capitalize
          @klass = Typekit::Record.const_get(name)
        end

        def process(response, attribute_collection)
          attribute_collection.map do |attributes|
            @klass.new(attributes)
          end
        end
      end
    end
  end
end
