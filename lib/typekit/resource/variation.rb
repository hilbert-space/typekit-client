module Typekit
  module Resource
    class Variation < Element::Base
      include Element::Association
      include Element::Serialization

      has_many :libraries
      belongs_to :family

      def initialize(*arguments)
        arguments[-1] = { id: arguments[-1] } if arguments[-1].is_a?(String)
        super(*arguments)
      end

      def as_json
        id
      end
    end
  end
end
