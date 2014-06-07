require 'spec_helper'

RSpec.describe 'Client#index kits' do
  let(:subject) { Typekit::Client.new(token: 'arbitrary') }

  context 'when successful' do
    options = { vcr: { cassette_name: 'index_kits_ok' } }

    let(:result) { subject.index(:kits) }

    it 'returns Records', options do
      expect(result.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Kit)
    end
  end

  context 'when unauthorized' do
    options = { vcr: { cassette_name: 'index_kits_unauthorized' } }

    it 'raises exceptions', options do
      expect { subject.index(:kits) }.to \
        raise_error(Typekit::Processing::Error, /Not authorized/i)
    end
  end
end
