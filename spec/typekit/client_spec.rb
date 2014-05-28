require 'spec_helper'
require 'typekit'

describe Typekit::Client do
  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Client.new(token: token) }

  describe '#index' do
    context 'when successful' do
      options = { vcr: { cassette_name: 'index_kits_ok' } }

      it 'returns hashs', options do
        result = subject.index(:kits)
        expect(result).to be_kind_of(Hash)
      end
    end

    context 'when unauthorized' do
      options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

      it 'raises exceptions', options do
        expect { subject.index(:kits) }.to \
          raise_error(Typekit::Error, /(authentication|authorized)/i)
      end
    end

    context 'when found' do
      options = { vcr: { cassette_name: 'show_families_calluna_found' } }

      it 'returns the Response as is', options do
        expect { subject.show(:families, 'calluna') }.not_to \
          raise_error
      end
    end
  end
end
