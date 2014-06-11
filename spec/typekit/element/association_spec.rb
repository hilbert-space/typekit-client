require 'spec_helper'

RSpec.describe Typekit::Element::Association do
  let(:subject_module) { Typekit::Element }
  let(:subject_class) { Class.new(subject_module::Base) }

  describe '.has_many' do
    let(:another_class) { Class.new(subject_module::Base) }

    before(:example) do
      allow(subject_module).to receive(:classify).and_return(another_class)
      subject_class.has_many(:sections)
    end

    it 'defines a getter method' do
      expect(subject_class.new).to respond_to(:sections)
    end

    describe 'the getter method' do
      context 'when the attributes of the association are given' do
        subject do
          subject_class.new(sections: [ { title: 'First' },
            { title: 'Second' } ])
        end

        it 'initializes the relation as a Collection' do
          expect(subject.sections).to be_kind_of(Typekit::Collection::Base)
        end

        it 'initializes a Collection based on the attributes' do
          expect(subject.sections.map(&:title)).to \
            contain_exactly('First', 'Second')
        end
      end

      context 'when the attributes of the association are given' do
        subject { subject_class.new }

        it 'raises an exception' do
          expect { subject.sections }.to \
            raise_error(Typekit::Error, /Not configured/i)
        end
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
