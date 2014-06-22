module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable

      def_delegators :@elements, :to_json, :each, :<=>

      def initialize(name, *arguments)
        collection_attributes = Helper.extract_array!(arguments)
        klass = Element.classify(name)
        @elements = collection_attributes.map do |attributes|
          if attributes.is_a?(klass)
            attributes
          else
            klass.new(*arguments, attributes)
          end
        end
      end

      def method_missing(*arguments)
        @elements.each { |element| element.send(*arguments) }
      end
    end
  end
end
