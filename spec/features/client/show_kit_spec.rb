require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client.show(:kits, 'xxx') }

  options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

  scenario 'Success', options do
    expect(result).to be_kind_of(Typekit::Resource::Kit)

    expect(result.families.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Family)

    result.families.each do |family|
      expect(family.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Variation)
    end
  end
end
