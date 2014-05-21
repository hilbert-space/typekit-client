module Typekit
  class Processor
    def initialize(format:)
      extend Parser.const_get(format.to_s.upcase)
    rescue NameError
      raise NameError, "The is no parser for the format '#{ format }'."
    end

    def process(response)
      return parse(response.content) if response.success?

      begin
        result = parse(response.content)
      rescue
        result = {}
      end

      raise Error.new(code: response.code, messages: result['errors'])
    end
  end
end
