require 'spec_helper'

RSpec.describe Typekit::Resource do
  include ResourceHelper
  extend ResourceHelper

  let(:subject_module) { Typekit::Resource }

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
