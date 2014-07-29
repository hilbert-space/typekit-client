require 'spec_helper'
require 'fixture/record/article'
require 'fixture/record/section'

RSpec.describe Typekit::Element::Base do
  let(:article_class) { Fixture::Record::Article }
  let(:section_class) { Fixture::Record::Section }

  describe '#new' do
    it 'treats options as attributes' do
      subject = article_class.new(title: 'Awesome')
      expect { subject.title = 'Superb' }.to \
        change { subject.title }.from('Awesome').to('Superb')
    end

    it 'symbolizes the names of the attributes' do
      subject = article_class.new('title' => 'Awesome')
      expect(subject.attributes.keys).to include(:title)
    end

    it 'appends the id attribute when missing' do
      subject = article_class.new(title: 'Awesome')
      expect(subject.id).to be nil
    end

    it 'does not affect the id attribute when present' do
      subject = article_class.new(id: 42, title: 'Awesome')
      expect(subject.id).to be 42
    end
  end

  describe '#attributes' do
    it 'returns all attributes' do
      subject = article_class.new(id: 1, title: 'Awesome')
      expect(subject.attributes).to eq(id: 1, title: 'Awesome')
    end

    it 'reflects attribute assignments' do
      subject = article_class.new(id: 1)
      subject.id = 42
      expect(subject.attributes).to eq(id: 42)
    end
  end

  describe '#attribute=' do
    it 'assigns arbitrary attributes' do
      subject = article_class.new
      subject.fourty_second = 42

      expect(subject.fourty_second).to be 42
      expect(subject.attributes.keys).to include(:fourty_second)
    end
  end

  describe '#become' do
    subject { article_class.new(id: 1, title: 'Awesome') }

    it 'copies the attributes of another element' do
      another = article_class.new(id: 2, name: 'Superb')
      subject.become(another)
      expect(subject.attributes).to  eq(id: 2, name: 'Superb')
    end

    it 'raises an exception when the classes do not match' do
      another = section_class.new(name: 'Superb')
      expect { subject.become(another) }.to \
        raise_error(ArgumentError, /Invalid class/i)
    end
  end
end
