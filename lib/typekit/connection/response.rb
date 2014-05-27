module Typekit
  module Connection
    class Response
      attr_reader :code, :content

      def initialize(code:, content:)
        @code = code
        @content = content
      end

      def success?
        @code == 200
      end

      def redirect?
        @code == 302
      end
    end
  end
end
