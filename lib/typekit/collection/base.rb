module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable

      def_delegators :@elements, :[], :to_json, :each, :<=>

      MASS_METHODS = [ :persistent! ]

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

      def to_a
        # Conventionally, Collections are serialized as Hashes:
        # { 0 => { ... }, 1 => { ... }, ... }
        Hash[(0...@elements.length).to_a.zip(@elements)]
      end

      def method_missing(method, *arguments, &block)
        return super unless MASS_METHODS.include?(method)
        @elements.each { |element| element.send(method, *arguments, &block) }
      end
    end
  end
end
