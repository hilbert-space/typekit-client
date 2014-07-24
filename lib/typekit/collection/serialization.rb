module Typekit
  module Collection
    module Serialization
      def serialize
        result = nil

        if klass.feature?(:serialization)
          result = elements.map(&:serialize)
          # FIXME: A nasty hack to empty collections.
          result = '' if result.empty?
        end

        result
      end
    end
  end
end
