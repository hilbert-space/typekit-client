module Typekit
  class Processor
    ERRORS = {
      400 => 'There are errors in the data provided by your application',
      401 => 'Authentication is needed to access the requested endpoint',
      403 => 'Your application has been rate limited',
      404 => 'You are requesting a resource that does not exist',
      500 => 'Typekit’s servers are unable to process the request',
      503 => 'Typekit’s API is offline for maintenance'
    }.freeze

    def initialize(format:)
      @parser = Parser.build(format)
    end

    def process(response)
      if response.success?
        data = @parser.process(response.content)
        process_success(response, data)
      else
        data = @parser.process(response.content) rescue {}
        process_failure(response, data)
      end
    end

    private

    def process_success(request, data)
      data
    end

    def process_failure(request, data)
      return data if request.redirect?
      message = data['errors'] || ERRORS[request.code] || 'Unknown server error'
      raise Error, Array(message).join(', ')
    end
  end
end
