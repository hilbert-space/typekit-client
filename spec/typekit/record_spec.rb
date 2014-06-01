require 'spec_helper'

describe Typekit::Record do
  let(:subject_module) { Typekit::Record }

  describe '.collections' do
    it 'knows the major collections' do
      expect(subject_module.collections).to \
        match_array(%i{families kits libraries variations})
    end
  end

  describe '.members' do
    it 'knows the major members' do
      expect(subject_module.members).to \
        match_array(%i{family kit library variation})
    end
  end

  describe '.collection?' do
    %w{family kit library variation kitten kittens}.each do |name|
      it "returns false for #{ name }" do
        expect(subject_module.collection?(name)).to be_false
      end
    end

    %w{families kits libraries variations}.each do |name|
      it "returns true for #{ name }" do
        expect(subject_module.collection?(name)).to be_true
      end
    end
  end

  describe '.member?' do
    %w{family kit library variation}.each do |name|
      it "returns true for #{ name }" do
        expect(subject_module.member?(name)).to be_true
      end
    end

    %w{families kits libraries variations kitten kittens}.each do |name|
      it "returns false for #{ name }" do
        expect(subject_module.member?(name)).to be_false
      end
    end
  end
end
