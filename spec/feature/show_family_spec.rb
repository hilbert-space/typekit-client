require 'rspec/bdd'

RSpec.feature 'Reading a family' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'show_families_xxx_ok' } }

    scenario 'Success using the id parameter', options do
      expect(family).to be_kind_of(Typekit::Record::Family)

      variations = family.variations
      expect(variations).to be_kind_of(Typekit::Collection::Base)

      variations.each do |variation|
        expect(variation).to be_kind_of(Typekit::Record::Variation)
      end

      libraries = family.libraries
      expect(libraries).to be_kind_of(Typekit::Collection::Base)

      libraries.each do |library|
        expect(library).to be_kind_of(Typekit::Record::Library)
      end
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

    options = { vcr: { cassette_name:
      'show_kits_xxx_families_yyy_show_family_yyy_ok' } }

    scenario 'Success', options do
      expect(family).to be_kind_of(Typekit::Record::Family)

      variations = family.variations
      expect(variations).to be_kind_of(Typekit::Collection::Base)

      variations.each do |variation|
        expect(variation).to be_kind_of(Typekit::Record::Variation)
      end

      expect(family).not_to be_complete

      libraries = family.libraries
      expect(variations).to be_kind_of(Typekit::Collection::Base)

      expect(family).to be_complete

      libraries.each do |library|
        expect(library).to be_kind_of(Typekit::Record::Library)
      end
    end
  end
end
