module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable
      include Serializable
      include Persistence

      def_delegators :elements, :[], :each, :size, :length, :empty?

      def initialize(name, *arguments)
        objects = Helper.extract_array!(arguments)

        @klass = Element.classify(name)
        @arguments = arguments
        @elements = []

        objects.each { |object| push(object) }
      end

      def push(object)
        object = object.is_a?(klass) ? object : klass.new(*arguments, object)
        elements << object
      end
      alias_method :<<, :push

      private

      attr_reader :klass, :arguments, :elements
    end
  end
end
