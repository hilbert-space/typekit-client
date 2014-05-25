require 'spec_helper'
require 'typekit'

describe Typekit::Helper do
  let(:subject_module) { Typekit::Helper }

  describe '.member_action?' do
    it 'returns true for RESTful actions operating on members' do
      [ :show, :update, :delete ].each do |action|
        expect(subject_module.member_action?(action)).to be_true
      end
    end

    it 'returns false for RESTful actions operating on collections' do
      [ :index, :create ].each do |action|
        expect(subject_module.member_action?(action)).to be_false
      end
    end

    it 'raises exceptions when encounters unknown actions' do
      expect { subject_module.member_action?(:rock) }.to \
        raise_error(Typekit::Helper::Error, /Unknown action/i)
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
