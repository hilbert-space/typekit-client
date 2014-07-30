require 'rspec/bdd'

RSpec.feature 'Reading a variation' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:variation) { client.show(:families, 'xxx', 'yyy') }

  options = { vcr: { cassette_name: 'show_families_xxx_yyy_ok' } }

  scenario 'Success', options do
    expect(variation).to be_kind_of(Typekit::Record::Variation)

    expect(variation.libraries.map(&:class).uniq).to \
      contain_exactly(Typekit::Record::Library)

    expect(variation.family).to be_kind_of(Typekit::Record::Family)
  end
end
