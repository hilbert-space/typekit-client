module Typekit
  module Converter
    class Element
      def initialize(*arguments)
        @arguments = arguments
      end

      def process(result, attributes)
        Typekit::Element.build(*@arguments, attributes)
      end
    end
  end
end
