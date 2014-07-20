require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Deleting a kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:result) { client.delete(:kits, 'xxx') }

  options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

  scenario 'Success', options do
    expect(result).to be true
  end
end
