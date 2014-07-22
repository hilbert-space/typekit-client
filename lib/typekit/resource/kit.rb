module Typekit
  module Resource
    class Kit < Element::Base
      include Element::Association
      include Element::Persistence
      include Element::Query
      include Element::Serialization

      has_many :families

      def loaded?
        persistent? && !families.nil?
      end

      def load!
        become(process(:show, id))
        true
      end
    end
  end
end
