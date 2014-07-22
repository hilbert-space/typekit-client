module Fixture
  module Resource
    class Article < Typekit::Element::Base
      has_many :sections
    end
  end
end
