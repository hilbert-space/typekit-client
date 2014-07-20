require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a family' do
  given(:client) { Typekit::Client.new(token: token) }

  context 'Searching by identifiers' do
    given(:result) { client.show(:families, 'xxx') }

    options = { vcr: { cassette_name: 'show_families_xxx_ok' } }

    scenario 'Success', options do
      expect(result).to be_kind_of(Typekit::Resource::Family)

      expect(result.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Variation)

      expect(result.libraries.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Library)
    end
  end

  context 'Searching in a Kit' do
    given(:result) { client.show(:kits, 'xxx', :families, 'yyy') }

    options = { vcr: { cassette_name: 'show_kits_xxx_families_yyy_ok' } }

    scenario 'Success', options do
      expect(result).to be_kind_of(Typekit::Resource::Family)

      expect(result.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Variation)
    end
  end

  context 'Searching by slugs' do
    given(:result) { client.show(:families, 'xxx') }

    options = { vcr: { cassette_name: 'show_families_xxx_found' } }

    scenario 'Success', options do
      expect(result).to be_kind_of(Typekit::Resource::Family)
    end
  end
end
