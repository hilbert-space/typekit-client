module Typekit
  module Dictionary
    class Errors
      ERRORS = {
        400 => 'There are errors in the data provided by your application',
        401 => 'Authentication is needed to access the requested endpoint',
        403 => 'Your application has been rate limited',
        404 => 'You are requesting a resource that does not exist',
        500 => 'The servers of Typekit are unable to process the request',
        503 => 'The Typekit API is offline for maintenance'
      }
      ERRORS.default = 'Unknown server error'
      ERRORS.freeze

      def process(response, errors)
        raise Error, Array(errors || ERRORS[response.code]).join(', ')
      end
    end
  end
end
