module Typekit
  module Resource
    class Library < Element::Base
      include Element::Association
      include Element::Query

      has_many :families
    end
  end
end
