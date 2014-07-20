require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Reading a kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client::Kit.find('xxx') }

  options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

  scenario 'Success', options do
    expect(result).to be_kind_of(Typekit::Resource::Kit)
  end

  options = { vcr: { cassette_name: 'show_kits_xxx_not_found' } }

  scenario 'Failure', options do
    expect { result }.to raise_error(Typekit::Error, /Not found/i)
  end
end
