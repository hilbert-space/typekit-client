module Typekit
  module Element
    module Serializable
      def as_json
        Hash[
          attributes.map do |k, v|
            [ k, v.respond_to?(:as_json) ? v.as_json : v ]
          end
        ]
      end
      alias_method :to_h, :as_json

      def to_json(*arguments)
        as_json.to_json(*arguments)
      end
    end
  end
end
