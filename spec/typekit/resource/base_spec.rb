require 'spec_helper'
require 'typekit'

describe Typekit::Resource::Base do
  let(:subject_class) { Typekit::Resource::Base }

  describe '.define_attributes' do
    it 'declares new attributes' do
      klass = Class.new(subject_class) { define_attributes :name }
      expect(klass.new).to respond_to(:name)
    end

    it 'does not affect the attributes of sibling classes' do
      klass1 = Class.new(subject_class) { define_attributes :one }
      klass2 = Class.new(subject_class) { define_attributes :two }
      expect(klass1.new).not_to respond_to(:two)
    end
  end

  describe '.attributes' do
    it 'returns the declared attributes' do
      klass = Class.new(subject_class) { define_attributes :id, :name }
      expect(klass.attributes).to include(:id, :name)
    end

    it 'returns the declared attributes as symbols' do
      klass = Class.new(subject_class) { define_attributes 'name' }
      expect(klass.attributes).to include(:name)
    end

    it 'does not jeopardize the integrity of the attributes' do
      klass = Class.new(subject_class) { define_attributes :name }
      klass.attributes.clear
      expect(klass.attributes).to include(:name)
    end
  end

  describe '#new' do
    let(:klass) { Class.new(subject_class) { define_attributes :name } }

    it 'assigns the values to the attributes of the resource' do
      expect(klass.new(name: 'Awesome').name).to eq('Awesome')
    end

    it 'ignores unknown attributes' do
      expect { klass.new(surname: 'Awesome') }.not_to raise_error
    end

    it 'handles attribute names given as strings' do
      expect(klass.new('name' => 'Awesome').name).to eq('Awesome')
    end
  end
end
