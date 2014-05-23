require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  describe '#define_resources' do
    it 'declares new resources' do
      subject.define_resources :kits
      expect(subject.resources).to include(:kits)
    end

    it 'declares nested resources' do
      subject.define_resources :families, scope: :kits
      expect(subject.resources[:kits]).to include(:families)
    end
  end

  describe '#resources' do
    it 'does not jeopardize the integrity of the declared resources' do
      subject.define_resources :kits
      subject.resources.clear
      expect(subject.resources).to include(:kits)
    end
  end

  describe '#draw' do
    it 'allows one to define a new resource' do
      subject.draw { resources :kits }
      expect(subject.resources).to include(:kits)
    end

    it 'allows one to define a nested resource' do
      subject.draw { resources(:kits) { resources :families } }
      expect(subject.resources[:kits]).to include(:families)
    end
  end
end
