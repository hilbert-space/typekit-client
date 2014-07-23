module Typekit
  module Record
    class Family < Element::Base
      include Element::Association
      include Element::Query
      include Element::Serialization

      has_many :libraries
      has_many :variations

      def loaded?
        attribute?(:libraries) && attribute?(:variations)
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
