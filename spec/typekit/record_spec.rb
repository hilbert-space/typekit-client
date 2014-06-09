require 'spec_helper'

RSpec.describe Typekit::Record do
  include ResourceHelper
  extend ResourceHelper

  let(:subject_module) { Typekit::Record }

  describe '.dictionary' do
    it 'returns a hash whose keys are symbolic names of Record classes' do
      expect(subject_module.dictionary.keys).to \
        contain_exactly(*record_symbols)
    end

    it 'returns a hash whose values are Record classes' do
      expect(subject_module.dictionary.values).to \
        contain_exactly(*record_classes)
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

    collection_dictionary.each do |name, klass|
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

  describe '.identify' do
    record_dictionary.each do |name, klass|
      it "converts :#{ name } into :record" do
        expect(subject_module.identify(name)).to eq(:record)
      end

      it "converts '#{ name }' into :record" do
        expect(subject_module.identify(name.to_s)).to eq(:record)
      end
    end

    collection_dictionary.each do |name, klass|
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
end
