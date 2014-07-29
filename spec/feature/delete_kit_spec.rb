require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Deleting a kit' do
  given(:client) { Typekit::Client.new(token: token) }

  shared_scenarios 'Adequate behavior' do
    options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

    scenario 'Success', options do
      expect(result).to be true
    end

    options = { vcr: { cassette_name: 'delete_kits_xxx_not_found' } }

    scenario 'Failure', options do
      expect { result }.to raise_error(Typekit::ServerError, /Not found/i)
    end
  end

  context 'Using Client' do
    given(:result) { client.delete(:kits, 'xxx') }

    include_scenarios 'Adequate behavior'
  end

  context 'Using Record' do
    given(:kit) do
      kit = client::Kit.new(id: 'xxx')
      kit.persistent!
      kit
    end

    given(:result) { kit.delete }

    include_scenarios 'Adequate behavior'
  end
end
