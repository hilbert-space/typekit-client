module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable
      include Serializable
      include Persistence

      def_delegators :elements, :[], :each, :size, :length

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

      private

      attr_reader :elements
    end
  end
end
