module Typekit
  module Collection
    module Persistence
      def persistent!
        return unless feature?(:persistence)
        elements.each(&:persistent!)
      end
    end
  end
end
