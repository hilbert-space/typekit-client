require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Deletion of a kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:kit) { Typekit::Resource::Kit.new(client, id: 'xxx') }

  options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

  scenario 'Success', options do
    expect(kit.delete).to be true
    expect(kit.deleted?).to be true
  end

  options = { vcr: { cassette_name: 'delete_kits_xxx_not_found' } }

  scenario 'Failure', options do
    expect { kit.delete }.to raise_error(Typekit::Error, /Not found/i)
  end
end
