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

      def load
        load!
      rescue ServerError
        false
      end
    end
  end
end
