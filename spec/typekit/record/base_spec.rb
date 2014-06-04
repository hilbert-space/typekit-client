require 'spec_helper'

RSpec.describe Typekit::Record::Base do
  let(:subject_class) { Typekit::Record::Base }

  describe '#new' do
    it 'treats each option as an attribute to keep track of' do
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
