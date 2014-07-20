require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a library' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client.show(:libraries, 'xxx') }

  options = { vcr: { cassette_name: 'show_libraries_xxx_ok' } }

  scenario 'Success', options do
    expect(result).to be_kind_of(Typekit::Resource::Library)

    expect(result.families.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Family)
  end
end
