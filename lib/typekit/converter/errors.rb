module Typekit
  module Converter
    class Errors
      def initialize(*)
      end

      def process(result, errors)
        raise ServerError.new(result.code, Array(errors).join(', '))
      end
    end
  end
end
