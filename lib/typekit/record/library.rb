module Typekit
  module Record
    class Library < Base
      has_attributes :id, :link, :name

      has_attributes :families, :pagination
    end
  end
end
