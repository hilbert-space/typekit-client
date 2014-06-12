require 'spec_helper'

RSpec.describe 'Resource::Kit.find' do
  let(:client) { Typekit::Client.new(token: 'arbitrary') }
  let(:subject) { client::Kit }

  options = { vcr: { cassette_name: 'show_kits_xxx_ok' } }

  it 'returns a Kit', options do
    expect(subject.find('xxx')).to be_kind_of(Typekit::Resource::Kit)
  end
end
