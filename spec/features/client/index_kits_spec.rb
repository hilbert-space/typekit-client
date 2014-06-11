require 'spec_helper'

RSpec.describe 'Client#index kits' do
  let(:subject) { Typekit::Client.new(token: 'arbitrary') }

  context 'when successful' do
    options = { vcr: { cassette_name: 'index_kits_ok' } }

    let(:result) { subject.index(:kits) }

    it 'returns Kits', options do
      expect(result.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Kit)
    end
  end

  context 'when unauthorized' do
    options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

    it 'raises exceptions', options do
      expect { subject.index(:kits) }.to \
        raise_error(Typekit::Processing::Error, /Not authorized/i)
    end
  end

  context 'when accessed via its alias #Kits.all' do
    options = { vcr: { cassette_name: 'index_kits_ok' } }

    let(:result) { subject::Kit.all }

    it 'works just fine', options do
      expect(result.map(&:class).uniq).to \
        contain_exactly(Typekit::Resource::Kit)
    end
  end
end
