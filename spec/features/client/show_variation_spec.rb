require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a variation' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client.show(:families, 'xxx', 'yyy') }

  options = { vcr: { cassette_name: 'show_families_xxx_yyy_ok' } }

  scenario 'Success', options do
    expect(result).to be_kind_of(Typekit::Resource::Variation)

    expect(result.libraries.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Library)

    expect(result.family).to be_kind_of(Typekit::Resource::Family)
  end
end
