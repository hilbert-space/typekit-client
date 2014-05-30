require 'spec_helper'
require 'typekit'

describe Typekit::Client do
  extend VCR::RSpec::Macros

  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Client.new(token: token) }

  describe '#index' do
    context 'when successful' do
      use_vcr_cassette 'index_kits_ok'

      it 'returns Records' do
        result = subject.index(:kits)
        expect(result.map(&:class).uniq).to eq([ Typekit::Record::Kit ])
      end
    end

    context 'when unauthorized' do
      use_vcr_cassette 'index_kits_unauthorized'

      it 'raises exceptions' do
        expect { subject.index(:kits) }.to \
          raise_error(Typekit::Processing::Error, /Not authorized/i)
      end
    end

    context 'when found' do
      use_vcr_cassette 'show_families_calluna_found'

      it 'returns the Response as is' do
        expect { subject.show(:families, 'calluna') }.not_to \
          raise_error
      end
    end
  end

  describe '#delete' do
    use_vcr_cassette 'delete_kits_xxx_ok'

    it 'returns true' do
      expect(subject.delete(:kits, 'xxx')).to be(true)
    end
  end
end
