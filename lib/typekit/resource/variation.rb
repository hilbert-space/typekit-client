module Typekit
  module Resource
    class Variation < Element::Base
      has_many :libraries
      belongs_to :family
    end
  end
end
