module Typekit
  class Translator
    def initialize(format:)
      @parser = Parser.build(format)
    end

    def process(response)
      data = @parser.process(response.content) rescue { errors: nil }

      unless data.is_a?(Hash) && data.length == 1
        raise Error, 'Unknown server response'
      end

      name, object = *data.first
      Dictionary.lookup(name).process(response, object)
    end
  end
end
