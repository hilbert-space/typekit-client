module Typekit
  module Processing
    module Converter
      class Unknown
        def initialize(name)
        end

        def process(response, object)
          object
        end
      end
    end
  end
end
