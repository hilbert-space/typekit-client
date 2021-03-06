module Typekit
  module Record
    class Variation < Element::Base
      include Element::Association
      include Element::Serialization

      has_many :libraries
      belongs_to :family

      def initialize(*arguments)
        arguments[-1] = { id: arguments[-1] } if arguments[-1].is_a?(String)
        super(*arguments)
      end

      def serialize
        id.to_s.split(':').last
      end
    end
  end
end
