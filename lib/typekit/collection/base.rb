module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable

      def_delegators :@elements, :to_json, :each, :<=>

      def initialize(name, collection_attributes = [], client: nil)
        klass = Element.classify(name)
        @elements = collection_attributes.map do |attributes|
          attributes = { id: attributes } unless attributes.is_a?(Hash)
          klass.new(attributes.merge(client: client))
        end
      end
    end
  end
end
