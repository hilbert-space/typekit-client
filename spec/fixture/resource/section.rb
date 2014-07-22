module Fixture
  module Resource
    class Section < Typekit::Element::Base
      belongs_to :article
    end
  end
end
