require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Creating a new kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:kit) { client::Kit.new(name: 'Megakit', domains: 'localhost') }

  options = { vcr: { cassette_name: 'create_kits_ok' } }

  scenario 'Success', options do
    expect(kit.save).to be true
    expect(kit.name).to eq('Megakit')
  end
end
