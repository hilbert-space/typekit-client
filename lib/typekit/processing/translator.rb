module Typekit
  module Processing
    class Translator
      def initialize(format:)
        @parser = Parser.build(format)
      end

      def process(response)
        data = @parser.process(response.body) rescue nil
        data = { nil => nil } unless data.is_a?(Hash) && data.length == 1
        name, object = *data.first
        Converter.build(name).process(response, object)
      end
    end
  end
end
