require 'forwardable'

module Typekit
  module Connection
    class Request
      extend Forwardable

      attr_reader :action, :parameters, :path, :node
      def_delegators :@path, :<<

      def initialize(action:, parameters: {})
        @action = action
        @parameters = parameters
        @path = []
      end

      def address
        @path.map(&:to_s).join('/')
      end

      def sign(node)
        @node = node
      end
    end
  end
end
