require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Updating a kit' do
  given(:client) { Typekit::Client.new(token: token) }

  given(:kit) do
    kit = client::Kit.new(:kits, id: 'xxx', name: 'Megakit',
      analytics: false, badge: true, domains: [ 'localhost' ])
    kit.persistent!
    kit
  end

  options = { vcr: { cassette_name: 'update_kits_xxx_ok' } }

  scenario 'Changing the name attribute', options do
    kit.name = 'Ultrakit'

    expect(kit.save).to be true
    expect(kit.name).to eq('Ultrakit')
  end

  options = { vcr: { cassette_name: 'update_kits_xxx_families_ok' } }

  scenario 'Adding a new family', options do
    kit.families << Typekit::Resource::Family.new(id: 'gkmg')

    expect(kit.save).to be true
    expect(kit.families.first.id).to eq('gkmg')
  end

  options = { vcr: { cassette_name: 'update_kits_xxx_families_variations_ok' } }

  scenario 'Adding a new family with specific variations', options do
    family = Typekit::Resource::Family.new(id: 'gkmg')
    family.variations << Typekit::Resource::Variation.new(id: 'n4')
    kit.families << family

    expect(kit.save).to be true
    expect(kit.families.first.variations.map(&:id)).to eq([ 'n4' ])
  end
end
