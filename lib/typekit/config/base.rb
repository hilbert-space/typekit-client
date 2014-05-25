module Typekit
  module Config
    class Base
      attr_reader :version, :format, :token

      def initialize(version: 1, format: :json, token:)
        @version = version
        @format = format
        @token = token
      end
    end
  end
end
