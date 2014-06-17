require 'spec_helper'

RSpec.describe 'Resource::Kit#update and #save' do
  let(:client) { Typekit::Client.new(token: token) }

  subject do
    VCR.insert_cassette('create_kits_ok')
    kit = client.create(:kits, name: 'Megakit', domains: 'localhost')
    VCR.eject_cassette
    kit
  end

  context 'when successful' do
    options = { vcr: { cassette_name: 'update_kits_ok' } }

    it 'updates the Kit', options do
      subject.name = 'Ultrakit'
      expect(subject.save).to be true
    end

    it 'takes changed attributes into account', options do
      subject.name = 'Ultrakit'
      subject.save
      expect(subject.name).to eq('Ultrakit')
    end
  end
end
