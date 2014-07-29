require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Publishing a kit' do
  given(:client) { Typekit::Client.new(token: token) }
  given(:kit) { client::Kit.new(:kits, id: 'xxx') }

  options = { vcr: { cassette_name: 'update_kits_xxx_publish_ok' } }

  scenario 'Success', options do
    date = kit.publish!

    expect(date).to be_kind_of(DateTime)
  end
end
