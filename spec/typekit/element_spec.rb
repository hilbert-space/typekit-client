require 'spec_helper'

RSpec.describe Typekit::Element do
  include ResourceHelper
  extend ResourceHelper

  let(:subject_module) { Typekit::Element }

  describe '.dictionary' do
    it 'returns a hash whose keys are symbolic names of Resource classes' do
      expect(subject_module.dictionary.keys).to \
        contain_exactly(*plural_resource_symbols)
    end

    it 'returns a hash whose values are Resource classes' do
      expect(subject_module.dictionary.values).to \
        contain_exactly(*resource_classes)
    end
  end

  describe '.classify' do
    resource_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Resource class" do
        expect(subject_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Resource class" do
        expect(subject_module.classify(name.to_s)).to eq(klass)
      end
    end

    plural_resource_dictionary.each do |name, klass|
      it "converts :#{ name } into the corresponding Resource class" do
        expect(subject_module.classify(name)).to eq(klass)
      end

      it "converts '#{ name }' into the corresponding Resouce class" do
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
    resource_dictionary.each do |name, klass|
      it "converts :#{ name } into :elment" do
        expect(subject_module.identify(name)).to eq(:element)
      end

      it "converts '#{ name }' into :element" do
        expect(subject_module.identify(name.to_s)).to eq(:element)
      end
    end

    plural_resource_dictionary.each do |name, klass|
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
