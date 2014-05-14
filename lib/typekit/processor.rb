module Typekit
  class Processor
    def initialize options
      parser = options[:format].to_s.upcase
      extend Parser.const_get parser
    rescue NameError
      raise "The parser '#{ parser }' cannot be found."
    end

    def process response
      return parse(response.content) if response.success?

      begin
        result = parse response.content
      rescue
        result = {}
      end

      if result.include? 'errors'
        raise Error.new code: response.code,
          message: Array(result['errors']).join(', ')
      else
        raise Error.new code: response.code
      end
    end
  end
end
