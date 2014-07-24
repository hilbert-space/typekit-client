module Typekit
  module Collection
    module Serialization
      def serialize
        elements.map(&:serialize) if klass.feature?(:serialization)
      end
    end
  end
end
