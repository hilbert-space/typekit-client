module Typekit
  module Resource
    class Library < Element::Base
      has_many :families
    end
  end
end
