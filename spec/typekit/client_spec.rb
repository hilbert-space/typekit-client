require 'spec_helper'

RSpec.describe Typekit::Client do
  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Client.new(token: token) }

  describe '#index' do
    context 'when successful' do
      options = { vcr: { cassette_name: 'index_kits_ok' } }

      it 'returns Records', options do
        result = subject.index(:kits)
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

    context 'when found' do
      options = { vcr: { cassette_name: 'show_families_calluna_found' } }

      it 'returns the Response as is', options do
        expect { subject.show(:families, 'calluna') }.not_to raise_error
      end
    end
  end

  describe '#show' do
    options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

    it 'returns a Record', options do
      result = subject.show(:kits, 'xxx')
      expect(result).to be_kind_of(Typekit::Record::Kit)
    end

    it 'returns a Record with Families', options do
      result = subject.show(:kits, 'xxx')
      expect(result.families.map(&:class).uniq).to \
        contain_exactly(Typekit::Record::Family)
    end
  end

  describe '#delete' do
    options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

    it 'returns true', options do
      expect(subject.delete(:kits, 'xxx')).to be true
    end
  end
end
