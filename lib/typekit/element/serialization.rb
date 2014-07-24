module Typekit
  module Element
    module Serialization
      def serialize
        Hash[
          attributes.map do |k, v|
            [ k, v.respond_to?(:serialize) ? v.serialize : v ]
          end
        ]
      end
    end
  end
end
