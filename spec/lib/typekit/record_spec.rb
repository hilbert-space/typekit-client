require 'spec_helper'
require 'fixture/record/article'

RSpec.describe Typekit::Record do
  include RecordHelper
  extend RecordHelper

  let(:subject_module) { Typekit::Record }

  describe '.identify' do
    record_dictionary.each do |name, klass|
      it "converts :#{ name } into :element" do
        expect(subject_module.identify(name)).to eq(:element)
      end

      it "converts '#{ name }' into :element" do
        expect(subject_module.identify(name.to_s)).to eq(:element)
      end
    end

    plural_record_dictionary.each do |name, klass|
      it "converts :#{ name } into :collection" do
        expect(subject_module.identify(name)).to eq(:collection)
      end

      it "converts '#{ name }' into :collection" do
        expect(subject_module.identify(name.to_s)).to eq(:collection)
      end
    end

    it 'returns nil for unknown names' do
      expect(subject_module.identify('smile')).to be nil
    end

    it 'returns nil for nil' do
      expect(subject_module.identify(nil)).to be nil
    end
  end

  describe '.build' do
    let(:base_class) { Fixture::Record::Article }

    let(:client) { double }
    let(:element_class) { subject_module.build(:articles, client) }

    it 'creates a new Element class' do
      expect(element_class < base_class).to be true
    end

    describe 'an instance of the new Element class' do
      subject { element_class.new }

      it 'makes use of the provided Client' do
        expect(client).to receive(:process).and_return(element_class.new)
        subject.save
      end
    end
  end
end
