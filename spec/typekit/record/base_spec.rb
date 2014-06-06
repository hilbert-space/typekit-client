require 'spec_helper'

RSpec.describe Typekit::Record::Base do
  let(:subject_module) { Typekit::Record }

  def create_class
    Class.new(subject_module::Base)
  end

  let(:subject_class) { create_class }

  describe '.has_many' do
    it 'declares one-to-many relations between Records' do
      expect { subject_class.has_many(:sections) }.not_to raise_error
    end
  end

  describe '.belongs_to' do
    it 'declares one-to-one relations between Records' do
      expect { subject_class.belongs_to(:article) }.not_to raise_error
    end
  end

  describe '#new' do
    it 'treats each option as an attribute' do
      subject = subject_class.new(name: 'Awesome')
      expect { subject.name = 'Superb' }.to \
        change { subject.name }.from('Awesome').to('Superb')
    end

    it 'handles attribute names given as strings' do
      subject = subject_class.new('name' => 'Awesome')
      expect { subject.name = 'Superb' }.to \
        change { subject.name }.from('Awesome').to('Superb')
    end
  end

  context 'when there are one-to-many relations defined' do
    let(:another_class) { create_class }

    before(:example) do
      allow(subject_module).to receive(:classify).and_return(another_class)
      subject_class.has_many(:sections)
    end

    describe '#new' do
      context 'when the attributes of the relations are given' do
        subject do
          subject_class.new(sections: [ { title: 'First' },
            { title: 'Second' } ])
        end

        it 'initializes relations as Collections' do
          expect(subject.sections).to be_kind_of(Typekit::Collection)
        end

        it 'initializes Collections based on the attributes' do
          expect(subject.sections.map(&:title)).to \
            contain_exactly('First', 'Second')
        end
      end

      context 'when the attributes of the relations are missing' do
        subject { subject_class.new }

        it 'does not initialize Collections' do
          expect { subject.sections }.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe '#attributes' do
    it 'returns all attributes' do
      subject = subject_class.new(id: 1, name: 'Awesome')
      expect(subject.attributes).to eq(id: 1, name: 'Awesome')
    end

    it 'reflects attribute assignments' do
      subject = subject_class.new(id: 1)
      subject.id = 42
      expect(subject.attributes).to eq(id: 42)
    end
  end
end
