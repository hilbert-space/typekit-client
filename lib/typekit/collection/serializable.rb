module Typekit
  module Collection
    module Serializable
      def as_json
        elements.map(&:as_json)
      end
      alias_method :to_a, :as_json
    end
  end
end
