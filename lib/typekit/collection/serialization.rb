module Typekit
  module Collection
    module Serialization
      def as_json
        elements.map(&:as_json)
      end
      alias_method :to_a, :as_json

      def to_json(*arguments)
        as_json.to_json(*arguments)
      end
    end
  end
end
