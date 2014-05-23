require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  describe '#define_collection' do
    it 'declares new resources' do
      subject.define_collection(:kits)
      expect(subject.collections).to include(:kits)
    end

    it 'declares nested resources' do
      subject.define_collection(:families, scope: :kits)
      expect(subject.collections[:kits]).to include(:families)
    end
  end

  describe '#collections' do
    it 'does not jeopardize the integrity of the declared resources' do
      subject.define_collection(:kits)
      subject.collections.clear
      expect(subject.collections).to include(:kits)
    end
  end

  describe '#define' do
    it 'allows one to declare new resources' do
      subject.define { collection(:kits) }
      expect(subject.collections).to include(:kits)
    end

    it 'allows one to declare nested resources' do
      subject.define { collection(:kits) { collection(:families) } }
      expect(subject.collections[:kits]).to include(:families)
    end
  end
end
