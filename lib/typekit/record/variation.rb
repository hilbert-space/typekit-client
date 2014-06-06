module Typekit
  module Record
    class Variation < Base
      has_many :libraries
      belongs_to :family
    end
  end
end
