module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable

      include Client::Proxy

      include Persistence
      include Serialization

      def_delegators :elements, :[], :each, :size, :length, :empty?
      def_delegator :klass, :feature?

      def initialize(name, *arguments)
        objects = Helper.extract_array!(arguments)

        @elements = []
        @klass = Element.classify(name)
        connect(arguments.first, name)

        objects.each { |object| push(object) }
      end

      def push(object)
        if object.is_a?(klass)
          object.connect(self)
          elements << object
        else
          elements << klass.new(self, object)
        end
      end
      alias_method :<<, :push

      private

      attr_reader :elements, :klass
    end
  end
end
