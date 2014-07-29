module Typekit
  module Record
    class Family < Element::Base
      include Element::Association
      include Element::Query
      include Element::Serialization

      has_many :libraries
      has_many :variations

      def complete?
        attribute?(:libraries) && attribute?(:variations)
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

      def serialize
        super(only: [:id, :subset, :variations])
      end
    end
  end
end
