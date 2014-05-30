require 'spec_helper'
require 'typekit'

describe Typekit::Record::Base do
  def create_class(*names)
    klass = Class.new(Typekit::Record::Base) { has_attributes(*names) }
    klass
  end

  let(:klass) { create_class(:id, :name) }

  describe '.has_attributes' do
    it 'declares getter methods for attributes' do
      expect { klass.new.name }.not_to raise_error
    end

    it 'declares setter methods for attributes' do
      expect { klass.new.name = 'Smiley' }.not_to raise_error
    end

    it 'does not affect the attributes of sibling classes' do
      another_klass = create_class(:surname)
      expect { klass.new.surname }.to raise_error(NoMethodError)
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

    it 'handles attribute names given as strings' do
      expect(klass.new('name' => 'Awesome').name).to eq('Awesome')
    end
  end

  context 'when an instance has been created with messy assignments' do
    let(:valid_attributes) { { id: 42, name: 'Life' } }
    let(:messy_attributes) { { id: 42, name: 'Life', extra: 'Meaning' } }
    let(:subject) { klass.new(messy_attributes) }

    describe '#attributes' do
      it 'returns the assignments of the declared attributes' do
        expect(subject.attributes).to eq(valid_attributes)
      end

      it 'changes when attributes get updated' do
        subject.id = 777
        subject.name = 'Luck'
        expect(subject.attributes).to eq(id: 777, name: 'Luck')
      end
    end

    describe '#raw_attributes' do
      it 'returns all assignments passed to the constructor' do
        expect(subject.raw_attributes).to eq(messy_attributes)
      end

      it 'does not change when attributes get updated' do
        subject.id = 777
        subject.name = 'Luck'
        expect(subject.raw_attributes).to eq(messy_attributes)
      end
    end
  end
end
