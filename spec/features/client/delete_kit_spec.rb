require 'spec_helper'

RSpec.describe 'Client#delete a kit' do
  let(:subject) { Typekit::Client.new(token: token) }

  options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

  let(:result) { subject.delete(:kits, 'xxx') }

  it 'returns true', options do
    expect(result).to be true
  end
end
