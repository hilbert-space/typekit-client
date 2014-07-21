module Typekit
  module Resource
    class Kit < Element::Base
      has_many :families

      def loaded?
        persistent? && !families.nil?
      end
    end
  end
end
