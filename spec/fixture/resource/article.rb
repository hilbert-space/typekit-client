module Fixture
  module Resource
    class Article < Typekit::Element::Base
      include Typekit::Element::Association
      include Typekit::Element::Persistence
      include Typekit::Element::Serialization

      has_many :sections
    end
  end
end
