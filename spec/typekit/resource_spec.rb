require 'spec_helper'

RSpec.describe Typekit::Resource do
  include ResourceHelper
  extend ResourceHelper

  let(:subject_module) { Typekit::Resource }

  describe '.identify' do
    resource_dictionary.each do |name, klass|
      it "converts :#{ name } into :element" do
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

  describe '.build' do
    let(:subject_class) { Class.new(Typekit::Element::Base) }
    let(:client) { double }

    before(:example) do
      allow(Typekit::Element).to receive(:classify).and_return(subject_class)
    end

    subject { subject_module.build(:cat, client) }

    it 'creates a new Element class' do
      expect(subject < subject_class).to be true
    end

    it 'creates a new Element class whose instances have a Client embedded' do
      expect(subject.new.client).to be client
    end
  end
end
