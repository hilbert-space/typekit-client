module Typekit
  module Element
    module Serialization
      def serialize(options = {})
        keys = attributes.keys
        keys = keys & Array(options[:only]) if options.key?(:only)
        Hash[
          keys.map do |key|
            value = attributes[key]
            value = value.serialize if value.respond_to?(:serialize)
            [key, value]
          end
        ]
      end
    end
  end
end
