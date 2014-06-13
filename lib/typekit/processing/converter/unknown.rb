module Typekit
  module Processing
    module Converter
      class Unknown
        def initialize(name)
          @name = name
        end

        def process(result, object)
          { @name => object }
        end
      end
    end
  end
end
