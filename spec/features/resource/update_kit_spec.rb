require 'spec_helper'

RSpec.describe 'Resource::Kit#change and #save' do
  let(:client) { Typekit::Client.new(token: token) }

  subject do
    VCR.insert_cassette('create_kits_ok')
    kit = client.create(:kits, name: 'Megakit', domains: 'localhost')
    VCR.eject_cassette
    kit
  end

  context 'when changing the name attribute' do
    options = { vcr: { cassette_name: 'update_kits_xxx_ok' } }

    it 'updates the Kit', options do
      subject.name = 'Ultrakit'
      expect(subject.save).to be true
    end

    it 'takes the change into account', options do
      subject.name = 'Ultrakit'
      subject.save
      expect(subject.name).to eq('Ultrakit')
    end
  end

  context 'when adding a new family' do
    options = { vcr: { cassette_name: 'update_kits_xxx_with_families_ok' } }

    it 'updates the Kit', options do
      family = Typekit::Resource::Family.new(id: 'gkmg')
      subject.families = [ family ]
      expect(subject.save).to be true
    end

    it 'takes the change into account', options do
      family = Typekit::Resource::Family.new(id: 'gkmg')
      subject.families = [ family ]
      subject.save
      expect(subject.families[0].id).to eq('gkmg')
    end
  end
end
