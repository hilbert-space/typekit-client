require 'spec_helper'

RSpec.describe Typekit::Helper do
  let(:subject_module) { Typekit::Helper }

  describe '.pluralize' do
    {
      'kit' => 'kits',
      'kits' => 'kits',
      'family' => 'families',
      'families' => 'families',
      'library' => 'libraries',
      'libraries' => 'libraries',
      'variation' => 'variations',
      'variations' => 'variations'
    }.each do |k, v|
      it "returns #{ v } for #{ k }" do
        expect(subject_module.pluralize(k)).to eq(v)
      end
    end
  end

  describe '.singularize' do
    {
      'kit' => 'kit',
      'kits' => 'kit',
      'family' => 'family',
      'families' => 'family',
      'library' => 'library',
      'libraries' => 'library',
      'variation' => 'variation',
      'variations' => 'variation'
    }.each do |k, v|
      it "returns #{ v } for #{ k }" do
        expect(subject_module.singularize(k)).to eq(v)
      end
    end
  end

  describe '.symbolize_keys' do
    it 'does what it says' do
      expect(subject_module.symbolize_keys('a' => { 'b' => 1 }, 'd' => 2)).to \
        eq(a: { 'b' => 1 }, d: 2)
    end
  end
end
