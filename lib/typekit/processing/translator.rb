module Typekit
  module Processing
    class Translator
      def process(result)
        unless result.is_a?(Hash) && result.length == 1
          raise Error, 'Unknown server response'
        end
        name, object = *result.first
        Converter.build(name).process(result, object)
      end
    end
  end
end
