require 'spec_helper'

RSpec.describe 'Resource::Kit.all' do
  let(:client) { Typekit::Client.new(token: token) }
  let(:subject) { client::Kit }

  options = { vcr: { cassette_name: 'index_kits_ok' } }

  it 'returns Kits', options do
    expect(subject.all.map(&:class).uniq).to \
      contain_exactly(Typekit::Resource::Kit)
  end
end
