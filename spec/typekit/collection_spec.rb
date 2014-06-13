require 'spec_helper'

RSpec.describe Typekit::Collection do
  let(:subject_module) { Typekit::Collection }
  let(:element_class) { Class.new(Typekit::Element::Base) }

  describe '.build' do
    before(:example) do
      allow(Typekit::Element).to receive(:classify).and_return(element_class)
    end

    subject { subject_module.build(:cats, [ { id: 4 }, { id: 2 } ]) }

    it 'creates a Collection' do
      expect(subject).to be_an_instance_of(subject_module::Base)
    end

    describe 'the Collection' do
      it 'contains Elements' do
        subject.each do |element|
          expect(element).to be_an_instance_of(element_class)
        end
      end

      it 'contains Elements that are persistent' do
        subject.each do |element|
          expect(element).to be_persistent
        end
      end
    end
  end
end
