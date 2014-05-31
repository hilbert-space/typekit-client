module Typekit
  module Connection
    class Response
      attr_reader :code, :body

      def initialize(code:, body:)
        @code = code
        @body = body
      end

      def success?
        [ 200, 302 ].include?(@code)
      end
    end
  end
end
