require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Listing kits' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'index_kits_show_kit_xxx_ok' } }

    scenario 'Success', options do
      kits = client::Kit.all

      expect(kits).to be_kind_of(Typekit::Collection::Base)
      expect(kits).not_to be_empty

      kits.each do |kit|
        expect(kit).to be_kind_of(Typekit::Resource::Kit)
        expect(kit).not_to be_loaded
        expect(kit.attributes.keys).to contain_exactly(:id, :link)
        expect(kit.families).to be nil
      end

      kit = kits.first

      expect(kit.load!).to be true
      expect(kit).to be_loaded
      expect(kit.families).to be_kind_of(Typekit::Collection::Base)
    end

    options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

    scenario 'Failure', options do
      expect { kits }.to raise_error(Typekit::Error, /Not authorized/i)
    end
  end

  context 'Using Client' do
    given(:kits) { client.index(:kits) }

    include_scenarios 'Adequate behavior'
  end

  context 'Using Resource' do
    given(:kits) { client::Kit.all }

    include_scenarios 'Adequate behavior'
  end
end