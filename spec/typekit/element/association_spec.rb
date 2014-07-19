require 'spec_helper'

RSpec.describe Typekit::Element::Association do
  let(:subject_module) { Typekit::Element }
  let(:subject_class) { Class.new(subject_module::Base) }

  describe '.has_many' do
    let(:nested_class) { Class.new(subject_module::Base) }
    let(:nested_collection_attributes) do
      [ { title: 'First' }, { title: 'Second' } ]
    end

    before(:example) do
      allow(subject_module).to receive(:classify).and_return(nested_class)
      subject_class.has_many(:sections)
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
      context 'when #new receives the attributes of the association' do
        subject { subject_class.new(sections: nested_collection_attributes) }

        it_behaves_like 'an adequate collection accessor'
      end

      context 'when #new does not receive the attributes of the association' do
        subject { subject_class.new }

        it 'raises an exception' do
          expect { subject.sections }.to \
            raise_error(Typekit::Error, /Not configured/i)
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
    before(:example) do
      subject_class.belongs_to(:article)
    end

    it 'defines a getter method' do
      expect(subject_class.new).to respond_to(:article)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are given' do
        subject { subject_class.new }

        it 'raises an exception' do
          expect { subject.article }.to \
            raise_error(Typekit::Error, /Not configured/i)
        end
      end
    end
  end
end
