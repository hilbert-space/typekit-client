require 'spec_helper'
require 'typekit'

describe Typekit::Helper do
  extend RESTHelper

  let(:subject_module) { Typekit::Helper }

  describe '.member_action?' do
    restful_member_actions.each do |action|
      it "returns true for the #{ action } member action" do
        expect(subject_module.member_action?(action)).to be_true
      end
    end

    restful_collection_actions.each do |action|
      it "returns false for the #{ action } collection action" do
        expect(subject_module.member_action?(action)).to be_false
      end
    end

    it 'raises exceptions when encounters unknown actions' do
      expect { subject_module.member_action?(:rock) }.to \
        raise_error(Typekit::Helper::Error, /Unknown action/i)
    end
  end

  describe '.translate_action' do
    rest_http_dictionary.each do |action, method|
      it "returns the #{ method } verb for the #{ action } action" do
        expect(subject_module.translate_action(action)).to eq(method)
      end
    end

    it 'raises exceptions when encounters unknown actions' do
      expect { subject_module.translate_action(:rock) }.to \
        raise_error(Typekit::Helper::Error, /Unknown action/i)
    end
  end

  describe '.pluralize' do
    {
      'kit' => 'kits',
      'kits' => 'kits',
      'family' => 'families',
      'families' => 'families',
      'library' => 'libraries',
      'libraries' => 'libraries',
      'variant' => 'variants',
      'variants' => 'variants'
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
      'variant' => 'variant',
      'variants' => 'variant'
    }.each do |k, v|
      it "returns #{ v } for #{ k }" do
        expect(subject_module.singularize(k)).to eq(v)
      end
    end
  end

  describe '.build_query' do
    it 'handels ordinary parameters' do
      queries = [
        'name=Megakit&domains=localhost',
        'domains=localhost&name=Megakit'
      ]
      query = subject_module.build_query(
        name: 'Megakit', domains: 'localhost')
      expect(queries).to include(query)
    end

    it 'handles parameters whose values are ordinary lists' do
      query = subject_module.build_query(
        domains: [ 'example.com', 'example.net' ])
      expect(query).to eq('domains[]=example.com&domains[]=example.net')
    end

    it 'handles parameters whose values are object lists' do
      queries = [
        'families[0][id]=gkmg&families[1][id]=asdf',
        'families[1][id]=asdf&families[0][id]=gkmg'
      ]
      query = subject_module.build_query(
        families: { 0 => { id: 'gkmg' }, 1 => { id: 'asdf' } })
      expect(queries).to include(query)
    end

    it 'converts integers to decimal strings' do
      query = subject_module.build_query(page: 42)
      expect(query).to eq('page=42')
    end

    it 'converts integers in object lists to decimal strings' do
      queries = [
        'primes[0][value]=2&primes[1][value]=3',
        'primes[1][value]=3&primes[0][value]=2'
      ]
      query = subject_module.build_query(
        primes: { 0 => { value: 2 }, 1 => { value: 3 } })
      expect(queries).to include(query)
    end

    it 'converts the logical true to the string true' do
      query = subject_module.build_query(badge: true)
      expect(query).to eq('badge=true')
    end

    it 'converts the logical false to the string false' do
      query = subject_module.build_query(badge: false)
      expect(query).to eq('badge=false')
    end
  end
end
