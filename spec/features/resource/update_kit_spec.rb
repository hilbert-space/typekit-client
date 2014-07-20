require 'spec_helper'

RSpec.describe 'Resource::Kit#change and #save' do
  let(:client) { Typekit::Client.new(token: token) }

  subject do
    kit = client::Kit.new(:kits, id: 'xxx', name: 'Megakit',
      analytics: false, badge: true, domains: [ 'localhost' ])
    kit.persistent!
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
    options = { vcr: { cassette_name: 'update_kits_xxx_families_ok' } }

    it 'updates the Kit', options do
      subject.families << Typekit::Resource::Family.new(id: 'gkmg')
      expect(subject.save).to be true
    end

    it 'takes the change into account', options do
      subject.families << Typekit::Resource::Family.new(id: 'gkmg')
      subject.save
      expect(subject.families.first.id).to eq('gkmg')
    end
  end

  context 'when adding a new family with specific variations' do
    options = { vcr: { cassette_name: 'update_kits_xxx_families_variations_ok' } }

    it 'updates the Kit', options do
      family = Typekit::Resource::Family.new(id: 'gkmg')
      family.variations << Typekit::Resource::Variation.new(id: 'n4')
      subject.families << family
      expect(subject.save).to be true
    end

    it 'takes the change into account', options do
      family = Typekit::Resource::Family.new(id: 'gkmg')
      family.variations << Typekit::Resource::Variation.new(id: 'n4')
      subject.families << family
      subject.save
      expect(subject.families.first.variations.map(&:id)).to eq([ 'n4' ])
    end
  end
end
