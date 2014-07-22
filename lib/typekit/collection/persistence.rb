module Typekit
  module Collection
    module Persistence
      def persistent!
        return unless klass.public_instance_methods.include?(:persistent!)
        elements.each { |element| element.persistent! }
      end
    end
  end
end
