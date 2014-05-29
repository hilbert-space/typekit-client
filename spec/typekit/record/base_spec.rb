require 'spec_helper'
require 'typekit'

describe Typekit::Record::Base do
  def create_class(*names)
    klass = Class.new(Typekit::Record::Base) { has_attributes(*names) }
    klass
  end

  let(:klass) { create_class(:id, :name) }

  describe '.has_attributes' do
    it 'declares new attributes' do
      expect(klass.new).to respond_to(:name)
    end

    it 'does not affect the attributes of sibling classes' do
      another_klass = create_class(:surname)
      expect(klass.new).not_to respond_to(:surname)
    end
  end

  describe '.has_many' do
    pending 'declares relations with other sibling classes' do
    end
  end

  describe '.attributes' do
    it 'returns the names of the declared attributes' do
      expect(klass.attributes).to include(:id, :name)
    end
  end

  describe '#new' do
    it 'assigns values to the declared attributes' do
      expect(klass.new(name: 'Awesome').name).to eq('Awesome')
    end

    it 'ignores unknown attributes' do
      expect { klass.new(surname: 'Awesome') }.not_to raise_error
    end
  end

  describe '#attributes' do
    pending 'returns the declared attributes' do
    end
  end

  describe '#raw_attributes' do
    pending 'returns all attributes passed to the constructor' do
    end
  end
end
