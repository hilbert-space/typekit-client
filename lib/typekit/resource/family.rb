module Typekit
  module Resource
    class Family < Element::Base
      has_many :libraries
      has_many :variations
    end
  end
end
