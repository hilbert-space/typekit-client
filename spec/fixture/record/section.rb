module Fixture
  module Record
    class Section < Typekit::Element::Base
      include Typekit::Element::Association
      include Typekit::Element::Serialization

      belongs_to :article
    end
  end
end
