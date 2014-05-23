require 'spec_helper'
require 'typekit'

describe Typekit::Client do
  RESTFULL_METHODS = [ :get, :post, :delete ]

  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Client.new(token: token) }

  it 'has the RESTfull methods supported by Typekit' do
    RESTFULL_METHODS.each do |method|
      expect(subject).to respond_to(method)
    end
  end

  describe '#get' do
    context 'the resuest has been successfull' do
      options = { vcr: { cassette_name: 'kits_ok' } }

      it 'returns an array of appropriate Elements', options do
        result = subject.get(:kits)
        result.each { |r| expect(r).to be_kind_of(Typekit::Element::Kit) }
      end
    end

    context 'the resuest has not been authorization' do
      options = { vcr: { cassette_name: 'kits_unauthorized' } }

      it 'raises an appropriate Error', options do
        expect { subject.get(:kits) }.to \
          raise_error(Typekit::Error, /(authentication|authorized)/i)
      end
    end
  end
end
