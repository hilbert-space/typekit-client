require 'spec_helper'
require 'fixture/record/article'

RSpec.describe Typekit::Element do
  include RecordHelper
  extend RecordHelper

  describe '.dictionary' do
    it 'returns a hash whose keys are symbolic names of Record classes' do
      expect(described_module.dictionary.keys).to \
        include(*plural_record_symbols)
    end

    it 'returns a hash whose values are Record classes' do
      expect(described_module.dictionary.values).to \
        include(*record_classes)
    end
  end

  describe '.classify' do
    record_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Record class" do
        expect(described_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Record class" do
        expect(described_module.classify(name.to_s)).to eq(klass)
      end
    end

    plural_record_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Record class" do
        expect(described_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Record class" do
        expect(described_module.classify(name.to_s)).to eq(klass)
      end
    end

    it 'returns nil for unknown names' do
      expect(described_module.classify('smile')).to be nil
    end

    it 'returns nil for nil' do
      expect(described_module.classify(nil)).to be nil
    end
  end

  describe '.build' do
    let(:article_class) { Fixture::Record::Article }
    subject { described_module.build(:articles) }

    it 'creates an instance of an Element class' do
      expect(subject).to be_an_instance_of(article_class)
    end

    describe 'the instance of an Element class' do
      it { should be_persistent }
    end
  end
end
