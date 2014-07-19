module Typekit
  module Collection
    module Persistence
      def persistent!
        elements.each { |element| element.persistent! }
      end
    end
  end
end
