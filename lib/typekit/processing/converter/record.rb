module Typekit
  module Processing
    module Converter
      class Record
        def initialize(name)
          @klass = Typekit::Record.const_get(name.to_s.capitalize)
        end

        def process(response, attributes)
          @klass.new(attributes)
        end
      end
    end
  end
end
