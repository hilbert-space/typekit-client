require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a kit' do
  given(:client) { Typekit::Client.new(token: token) }

  options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

  scenario 'Success', options do
    kit = client::Kit.find('xxx')

    expect(kit).to be_kind_of(Typekit::Resource::Kit)
    expect(kit).to be_loaded

    families = kit.families

    expect(families).to be_kind_of(Typekit::Collection::Base)
    expect(families).not_to be_empty

    families.each do |family|
      expect(family).to be_kind_of(Typekit::Resource::Family)
      expect(family).to be_loaded
    end

    variations = families.first.variations

    expect(variations).to be_kind_of(Typekit::Collection::Base)
    expect(variations).not_to be_empty

    variations.each do |variation|
      expect(variation).to be_kind_of(Typekit::Resource::Variation)
    end
  end

  options = { vcr: { cassette_name: 'show_kits_xxx_not_found' } }

  scenario 'Failure', options do
    expect { client::Kit.find('xxx') }.to \
      raise_error(Typekit::Error, /Not found/i)
  end
end
