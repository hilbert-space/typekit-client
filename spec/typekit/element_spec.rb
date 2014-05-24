require 'spec_helper'
require 'typekit'

describe Typekit::Element do
  describe '.classes' do
    it 'returns the classes that an Element can be an instance of' do
      klass = Class.new(Typekit::Element::Base)
      expect(Typekit::Element.classes).to include(klass)
    end
  end

  describe '.collections' do
    it 'returns the collections that an Element can belong to' do
      Typekit::Element::Letter = Class.new(Typekit::Element::Base)
      expect(Typekit::Element.collections).to include(:letters)
    end
  end
end
