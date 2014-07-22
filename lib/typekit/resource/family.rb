module Typekit
  module Resource
    class Family < Element::Base
      include Element::Association
      include Element::Query
      include Element::Serialization

      has_many :libraries
      has_many :variations

      def loaded?
        !variations.nil?
      end
    end
  end
end
