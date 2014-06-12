require 'spec_helper'

RSpec.describe 'Client#show a kit' do
  let(:subject) { Typekit::Client.new(token: 'arbitrary') }

  options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

  let(:result) { subject.show(:kits, 'xxx') }

  it 'returns a Kit', options do
    expect(result).to be_kind_of(Typekit::Resource::Kit)
  end

  it 'returns a Kit with Families', options do
    expect(result.families.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Family)
  end

  it 'returns a Kit with Families with Variations', options do
    result.families.each do |family|
      expect(family.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Variation)
    end
  end
end
