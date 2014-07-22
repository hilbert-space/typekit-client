require 'spec_helper'
require 'fixture/resource/article'
require 'fixture/resource/section'

RSpec.describe Typekit::Element::Association do
  describe '.has_many' do
    let(:subject_class) { Fixture::Resource::Article }
    let(:nested_class) { Fixture::Resource::Section }

    let(:nested_collection_attributes) do
      [ { title: 'First' }, { title: 'Second' } ]
    end

    shared_examples 'an adequate collection accessor' do
      it 'initializes the relation as a Collection' do
        expect(subject.sections).to be_kind_of(Typekit::Collection::Base)
      end

      describe 'the Collection' do
        it 'is based on the attributes' do
          expect(subject.sections.map(&:title)).to \
            contain_exactly('First', 'Second')
        end
      end
    end

    it 'defines a getter method' do
      expect(subject_class.new).to respond_to(:sections)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are given' do
        subject { subject_class.new(sections: nested_collection_attributes) }

        it_behaves_like 'an adequate collection accessor'
      end

      context 'when the attributes of the association are not given' do
        subject { subject_class.new }

        it 'returns an empty Collection when new' do
          expect(subject.sections).to be_kind_of(Typekit::Collection::Base)
          expect(subject.sections.size).to be_zero
        end

        it 'returns nil' do
          subject.persistent!
          expect(subject.sections).to be nil
        end
      end
    end

    it 'defines a setter method' do
      expect(subject_class.new).to respond_to(:sections=)
    end

    describe 'the setter method' do
      subject { subject_class.new }

      context 'when receives plain attributes' do
        before(:example) { subject.sections = nested_collection_attributes }

        it_behaves_like 'an adequate collection accessor'
      end

      context 'when receives arrays of Elements' do
        before(:example) do
          subject.sections = nested_collection_attributes.map do |attributes|
            nested_class.new(attributes)
          end
        end

        it_behaves_like 'an adequate collection accessor'
      end
    end
  end

  describe '.belongs_to' do
    let(:subject_class) { Fixture::Resource::Section }

    it 'defines a getter method' do
      expect(subject_class.new).to respond_to(:article)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are not given' do
        subject { subject_class.new }

        it 'returns nil' do
          expect(subject.article).to be nil
        end
      end
    end
  end
end
