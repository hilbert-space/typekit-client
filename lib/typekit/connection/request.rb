require 'forwardable'

module Typekit
  module Connection
    class Request
      extend Forwardable

      attr_reader :action, :parameters, :path
      def_delegators :@path, :<<

      def initialize(action:, parameters: {})
        @action = action
        @parameters = parameters
        @path = []
      end

      def address
        # TODO: cache?
        @path.map(&:to_s).join('/')
      end
    end
  end
end
