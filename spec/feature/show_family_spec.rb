require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a family' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'show_families_xxx_ok' } }

    scenario 'Success using the id parameter', options do
      expect(family).to be_kind_of(Typekit::Record::Family)

      expect(family.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Variation)

      expect(family.libraries.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Library)
    end

    options = { vcr: { cassette_name: 'show_families_xxx_found' } }

    scenario 'Success using the slug parameter', options do
      expect(family).to be_kind_of(Typekit::Record::Family)
    end
  end

  context 'Searching directly using Client' do
    given(:family) { client.show(:families, 'xxx') }

    include_scenarios 'Adequate behavior'
  end

  context 'Searching directly using Record' do
    given(:family) { client::Family.find('xxx') }

    include_scenarios 'Adequate behavior'
  end

  context 'Searching in a Kit using Client' do
    given(:family) { client.show(:kits, 'xxx', :families, 'yyy') }

    options = { vcr: { cassette_name: 'show_kits_xxx_families_yyy_ok' } }

    scenario 'Success', options do
      expect(family).to be_kind_of(Typekit::Record::Family)

      expect(family.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Variation)
    end
  end
end
