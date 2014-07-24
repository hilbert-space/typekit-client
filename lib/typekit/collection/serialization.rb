module Typekit
  module Collection
    module Serialization
      def serialize
        elements.map(&:serialize)
      end
    end
  end
end
