module Typekit
  module Processing
    module Converter
      class Element
        def initialize(name)
          @name = name
        end

        def process(response, attributes)
          Typekit::Element.build(@name, attributes)
        end
      end
    end
  end
end
