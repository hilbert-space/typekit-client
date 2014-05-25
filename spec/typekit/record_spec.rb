require 'spec_helper'
require 'typekit'

describe Typekit::Record do
  def create_class(*names)
    klass = Class.new(Typekit::Record::Base) { define_attributes(*names) }
    klass
  end

  describe '.define_attributes' do
    it 'declares new attributes' do
      klass = create_class(:name)
      expect(klass.new).to respond_to(:name)
    end

    it 'does not affect the attributes of sibling classes' do
      klass1 = create_class(:one)
      klass2 = create_class(:two)
      expect(klass1.new).not_to respond_to(:two)
    end
  end

  describe '.attributes' do
    it 'returns the declared attributes' do
      klass = create_class(:id, :name)
      expect(klass.attributes).to include(:id, :name)
    end
  end

  describe '#new' do
    let(:klass) { create_class(:name) }

    it 'assigns the values to the attributes of the resource' do
      expect(klass.new(name: 'Awesome').name).to eq('Awesome')
    end

    it 'ignores unknown attributes' do
      expect { klass.new(surname: 'Awesome') }.not_to raise_error
    end
  end
end
