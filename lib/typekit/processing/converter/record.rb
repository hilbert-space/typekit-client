module Typekit
  module Processing
    module Converter
      class Record
        def initialize(name)
          @name = name
        end

        def process(response, attributes)
          Typekit::Record.build(@name, attributes)
        end
      end
    end
  end
end
