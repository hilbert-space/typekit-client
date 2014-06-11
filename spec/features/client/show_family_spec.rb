require 'spec_helper'

RSpec.describe 'Client#show a family' do
  let(:subject) { Typekit::Client.new(token: 'arbitrary') }

  shared_examples 'an adequate reader' do |options|
    it 'returns a Family', options do
      expect(result).to be_kind_of(Typekit::Resource::Family)
    end

    it 'returns a Family with Variations', options do
      expect(result.variations.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Variation)
    end
  end

  context 'when looking up directly' do
    options = { vcr: { cassette_name: 'show_families_xxx_ok' } }

    let(:result) { subject.show(:families, 'xxx') }

    it_behaves_like 'an adequate reader', options

    it 'returns a Family with Libraries', options do
      expect(result.libraries.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Library)
    end
  end

  context 'when looking up through a kit' do
    options = { vcr: { cassette_name: 'show_kits_xxx_families_yyy_ok' } }

    let(:result) { subject.show(:kits, 'xxx', :families, 'yyy') }

    it_behaves_like 'an adequate reader', options
  end

  context 'when looking up directly via slugs' do
    options = { vcr: { cassette_name: 'show_families_xxx_found' } }

    let(:result) { subject.show(:families, 'xxx') }

    it 'returns a Family', options do
      expect(result).to be_kind_of(Typekit::Resource::Family)
    end
  end
end
