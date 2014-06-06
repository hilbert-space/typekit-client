module Typekit
  module Processing
    module Converter
      class Record
        def initialize(name)
          @klass = Typekit::Record.classify(name)
          raise Error, 'Unknown class' unless @klass
        end

        def process(response, attributes)
          @klass.new(attributes)
        end
      end
    end
  end
end
