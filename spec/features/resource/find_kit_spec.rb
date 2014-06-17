require 'spec_helper'

RSpec.describe 'Resource::Kit.find' do
  let(:client) { Typekit::Client.new(token: 'arbitrary') }
  let(:subject) { client::Kit }

  context 'when successful' do
    options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

    it 'returns a Kit', options do
      expect(subject.find('xxx')).to be_kind_of(Typekit::Resource::Kit)
    end
  end

  context 'when not found' do
    options = { vcr: { cassette_name: 'show_kits_xxx_not_found' } }

    it 'raises an exception', options do
      expect { subject.find('xxx') }.to \
        raise_error(Typekit::Error, /Not found/i)
    end
  end
end
