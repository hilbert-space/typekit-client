require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Listing kits' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client::Kit.all }

  options = { vcr: { cassette_name: 'index_kits_ok' } }

  scenario 'Success', options do
    expect(result.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Kit)
  end
end
