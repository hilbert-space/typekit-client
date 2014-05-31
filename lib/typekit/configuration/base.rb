module Typekit
  module Configuration
    class Base
      attr_reader :version, :format, :token

      def initialize(version: 1, format: :json, token:)
        @version = version
        @format = format
        @token = token
      end

      [ :mapper, :dispatcher, :translator ].each do |component|
        class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{ component }
            @#{ component } ||= build_#{ component }
          end
        METHOD
      end
    end
  end
end
