require 'spec_helper'

RSpec.describe 'Resource::Base#delete a kit' do
  let(:client) { Typekit::Client.new(token: 'arbitrary') }
  let(:subject) { Typekit::Resource::Kit.new(id: 'xxx', client: client) }

  options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

  it 'deletes the Kit', options do
    expect(subject.delete).to be true
  end
end
