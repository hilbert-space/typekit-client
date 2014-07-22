require 'spec_helper'
require 'fixture/resource/article'
require 'fixture/resource/section'

RSpec.describe Typekit::Element::Base do
  let(:subject_class) { Fixture::Resource::Article }
  let(:another_class) { Fixture::Resource::Section }

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

  describe '#become' do
    subject { subject_class.new(id: 42, name: 'Awesome') }

    it 'copies the attributes of another element' do
      another = subject_class.new(name: 'Superb', surname: 'Squared')
      subject.become(another)
      expect(subject.attributes).to eq(name: 'Superb', surname: 'Squared')
    end

    it 'raises an exception when the classes do not match' do
      another = another_class.new(name: 'Superb')
      expect { subject.become(another) }.to \
        raise_error(ArgumentError, /Invalid class/i)
    end
  end
end
