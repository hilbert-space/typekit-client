require 'spec_helper'
require 'fixture/record/article'
require 'fixture/record/section'

RSpec.describe Typekit::Element::Association do
  let(:article_class) { Fixture::Record::Article }
  let(:section_class) { Fixture::Record::Section }

  describe '.has_many' do
    let(:nested_collection_attributes) do
      [{ title: 'First' }, { title: 'Second' }]
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
      expect(article_class.new).to respond_to(:sections)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are given' do
        subject { article_class.new(sections: nested_collection_attributes) }

        it_behaves_like 'an adequate collection accessor'
      end

      context 'when the attributes of the association are not given' do
        it 'returns an empty Collection when new' do
          subject = article_class.new

          expect(subject).not_to receive(:load!)
          expect(subject.sections).to be_kind_of(Typekit::Collection::Base)
          expect(subject.sections).to be_empty
        end

        it 'loads the association when not new' do
          subject = article_class.new(id: 42)

          expect(subject).to receive(:load!).and_throw(:break)
          catch(:break) { subject.sections }
        end
      end
    end

    it 'defines a setter method' do
      expect(article_class.new).to respond_to(:sections=)
    end

    describe 'the setter method' do
      subject { article_class.new }

      context 'when receives plain attributes' do
        before(:example) { subject.sections = nested_collection_attributes }

        it_behaves_like 'an adequate collection accessor'
      end

      context 'when receives arrays of Elements' do
        before(:example) do
          subject.sections = nested_collection_attributes.map do |attributes|
            section_class.new(attributes)
          end
        end

        it_behaves_like 'an adequate collection accessor'
      end
    end
  end

  describe '.belongs_to' do
    it 'defines a getter method' do
      expect(section_class.new).to respond_to(:article)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are not given' do
        subject { section_class.new }

        it 'returns nil' do
          expect(subject.article).to be nil
        end
      end
    end
  end
end
