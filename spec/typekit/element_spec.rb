require 'spec_helper'
require 'fixture/record/article'

RSpec.describe Typekit::Element do
  include RecordHelper
  extend RecordHelper

  let(:subject_module) { Typekit::Element }

  describe '.dictionary' do
    it 'returns a hash whose keys are symbolic names of Record classes' do
      expect(subject_module.dictionary.keys).to \
        include(*plural_record_symbols)
    end

    it 'returns a hash whose values are Record classes' do
      expect(subject_module.dictionary.values).to \
        include(*record_classes)
    end
  end

  describe '.classify' do
    record_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Record class" do
        expect(subject_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Record class" do
        expect(subject_module.classify(name.to_s)).to eq(klass)
      end
    end

    plural_record_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Record class" do
        expect(subject_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Record class" do
        expect(subject_module.classify(name.to_s)).to eq(klass)
      end
    end

    it 'returns nil for unknown names' do
      expect(subject_module.classify('smile')).to be nil
    end

    it 'returns nil for nil' do
      expect(subject_module.classify(nil)).to be nil
    end
  end

  describe '.build' do
    let(:subject_class) { Fixture::Record::Article }

    before(:example) do
      allow(subject_module).to receive(:classify).and_return(subject_class)
    end

    subject { subject_module.build(:cat) }

    it 'creates an instance of an Element class' do
      expect(subject).to be_an_instance_of(subject_class)
    end

    describe 'the instance of an Element class' do
      it { should be_persistent }
    end
  end
end
