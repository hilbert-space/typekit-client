module Typekit
  module Resource
    class Kit < Element::Base
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
