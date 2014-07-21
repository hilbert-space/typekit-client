require 'spec_helper'

RSpec.describe Typekit::Element do
  include ResourceHelper
  extend ResourceHelper

  let(:subject_module) { Typekit::Element }

  describe '.dictionary' do
    it 'returns a hash whose keys are symbolic names of Resource classes' do
      expect(subject_module.dictionary.keys).to \
        include(*plural_resource_symbols)
    end

    it 'returns a hash whose values are Resource classes' do
      expect(subject_module.dictionary.values).to \
        include(*resource_classes)
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

      it "converts '#{ name }' into the corresponding Resource class" do
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
    let(:subject_class) { Class.new(subject_module::Base) }

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
