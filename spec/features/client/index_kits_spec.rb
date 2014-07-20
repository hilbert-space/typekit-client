require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Listing kits' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client.index(:kits) }

  options = { vcr: { cassette_name: 'index_kits_ok' } }

  scenario 'Success', options do
    expect(result.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Kit)
  end

  options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

  scenario 'Failure', options do
    expect { result }.to raise_error(Typekit::Error, /Not authorized/i)
  end
end
