module Typekit
  module Record
    class Family < Base
      has_many :libraries
      has_many :variations
    end
  end
end
