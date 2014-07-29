module Typekit
  module Record
    class Kit < Element::Base
      include Element::Association
      include Element::Persistence
      include Element::Query
      include Element::Serialization

      has_many :families

      def complete?
        !persistent? || attribute?(:families)
      end

      def load!
        become(process(:show, id))
        true
      end

      def publish!
        process(:update, id, :publish)
      end

      [:load, :publish].each do |method|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{method}(*arguments)
            #{method}!(*arguments)
          rescue ServerError
            false
          end
        CODE
      end
    end
  end
end
