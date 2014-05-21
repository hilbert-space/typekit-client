module Typekit
  class Error < ::StandardError
    MESSAGES = {
      400 => 'There are errors in the data provided by your application.',
      401 => 'Authentication is needed to access the requested endpoint.',
      403 => 'Your application has been rate limited.',
      404 => 'You are requesting a resource that does not exist.',
      500 => 'Typekit’s servers are unable to process the request.',
      503 => 'Typekit’s API is offline for maintenance.'
    }

    def initialize(code:, messages: nil)
      if messages
        super Array(messages).join(', ')
      elsif MESSAGES.include?(code)
        super MESSAGES[code]
      else
        super 'An unknown error has occurred.'
      end
    end
  end
end
