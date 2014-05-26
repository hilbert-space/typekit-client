require 'spec_helper'
require 'typekit'

describe Typekit::Connection::Adaptor do
  let(:method) { :get }
  let(:address) { 'https://typekit.com/api/v1/json/kits' }
  options = { vcr: { cassette_name: 'index_kits_ok' } }

  [ 'Standard' ].each do |adaptor|
    subject { Typekit::Connection::Adaptor.const_get(adaptor).new }

    describe "#{ adaptor }.process" do
      it 'returns the code and content of the response', options do
        response = subject.process(method, address)
        expect(response.keys).to match_array([ :code, :content ])
      end

      it 'raises exceptions when encounters unknown methods' do
        expect { subject.process(:smile, address) }.to \
          raise_error(Typekit::Connection::Error, /Invalid method/i)
      end
    end
  end
end
