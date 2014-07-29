require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Creating a new kit' do
  given(:client) { Typekit::Client.new(token: token) }

  options = { vcr: { cassette_name: 'create_kits_ok' } }

  scenario 'Success via #new and #save', options do
    kit = client::Kit.new(name: 'Megakit', domains: 'localhost')
    kit.save

    expect(kit).to be_persistent
    expect(kit.name).to eq('Megakit')
  end

  scenario 'Success via #create', options do
    kit = client::Kit.create(name: 'Megakit', domains: 'localhost')

    expect(kit).to be_persistent
    expect(kit.name).to eq('Megakit')
  end
end
