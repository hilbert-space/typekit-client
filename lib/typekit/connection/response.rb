module Typekit
  module Connection
    class Response
      attr_reader :code, :content

      def initialize(code:, content:)
        @code = code
        @content = content
      end

      def success?
        [ 200, 302 ].include?(@code)
      end
    end
  end
end
