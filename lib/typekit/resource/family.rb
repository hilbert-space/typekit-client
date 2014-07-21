module Typekit
  module Resource
    class Family < Element::Base
      has_many :libraries
      has_many :variations

      def loaded?
        persistent? && !variations.nil?
      end
    end
  end
end
