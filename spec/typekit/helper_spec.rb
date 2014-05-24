require 'spec_helper'
require 'typekit'

describe Typekit::Helper do
  let(:subject_class) { Typekit::Helper }

  describe '#pluralize' do
    it 'knows some important words' do
      {
        'kit' => 'kits',
        'kits' => 'kits',
        'family' => 'families',
        'families' => 'families',
        'library' => 'libraries',
        'libraries' => 'libraries'
      }.each do |input, output|
        expect(subject_class.pluralize(input)).to eq(output)
      end
    end
  end

  describe '#build_query' do
    it 'handels ordinary parameters' do
      queries = [
        'name=Megakit&domains=localhost',
        'domains=localhost&name=Megakit'
      ]
      query = subject_class.build_query(
        name: 'Megakit', domains: 'localhost')
      expect(queries).to include(query)
    end

    it 'handles parameters whose values are ordinary lists' do
      query = subject_class.build_query(
        domains: [ 'example.com', 'example.net' ])
      expect(query).to eq('domains[]=example.com&domains[]=example.net')
    end

    it 'handles parameters whose values are object lists' do
      queries = [
        'families[0][id]=gkmg&families[1][id]=asdf',
        'families[1][id]=asdf&families[0][id]=gkmg'
      ]
      query = subject_class.build_query(
        families: { 0 => { id: 'gkmg' }, 1 => { id: 'asdf' } })
      expect(queries).to include(query)
    end

    it 'converts integers to decimal strings' do
      query = subject_class.build_query(page: 42)
      expect(query).to eq('page=42')
    end

    it 'converts integers in object lists to decimal strings' do
      queries = [
        'primes[0][value]=2&primes[1][value]=3',
        'primes[1][value]=3&primes[0][value]=2'
      ]
      query = subject_class.build_query(
        primes: { 0 => { value: 2 }, 1 => { value: 3 } })
      expect(queries).to include(query)
    end

    it 'converts the logical true to the string true' do
      query = subject_class.build_query(badge: true)
      expect(query).to eq('badge=true')
    end

    it 'converts the logical false to the string false' do
      query = subject_class.build_query(badge: false)
      expect(query).to eq('badge=false')
    end
  end
end
