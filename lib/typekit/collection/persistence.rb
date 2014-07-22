module Typekit
  module Collection
    module Persistence
      def persistent!
        return unless feature?(:persistence)
        elements.each { |element| element.persistent! }
      end
    end
  end
end
