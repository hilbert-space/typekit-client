module Typekit
  module Record
    class Kit < Element::Base
      include Element::Association
      include Element::Persistence
      include Element::Query
      include Element::Serialization

      has_many :families

      def loaded?
        !persistent? || attribute?(:families)
      end

      def load
        process(:show, id)
      end

      def load!
        become(load)
      end
    end
  end
end
