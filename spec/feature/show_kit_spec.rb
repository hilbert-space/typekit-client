require 'rspec/bdd'

RSpec.feature 'Reading a kit' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'show_kits_xxx_show_family_yyy_ok' } }

    scenario 'Success', options do
      expect(kit).to be_kind_of(Typekit::Record::Kit)
      expect(kit).to be_complete

      families = kit.families

      expect(families).to be_kind_of(Typekit::Collection::Base)
      expect(families).not_to be_empty

      families.each do |family|
        expect(family).to be_kind_of(Typekit::Record::Family)
        expect(family).not_to be_complete
      end

      family = families.first
      expect(family.load!).to be true
      expect(family).to be_complete

      variations = family.variations

      expect(variations).to be_kind_of(Typekit::Collection::Base)
      expect(variations).not_to be_empty

      variations.each do |variation|
        expect(variation).to be_kind_of(Typekit::Record::Variation)
      end
    end

    options = { vcr: { cassette_name: 'show_kits_xxx_not_found' } }

    scenario 'Failure', options do
      expect { kit }.to raise_error(Typekit::ServerError, /Not found/i)
    end
  end

  context 'Using Client' do
    given(:kit) { client.show(:kits, 'xxx') }

    include_scenarios 'Adequate behavior'
  end

  context 'Using Record' do
    given(:kit) { client::Kit.find!('xxx') }

    include_scenarios 'Adequate behavior'
  end
end
