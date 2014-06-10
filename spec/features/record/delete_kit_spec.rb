require 'spec_helper'

RSpec.describe 'Record::Base#delete a kit' do
  let(:client) { Typekit::Client.new(token: 'arbitrary') }
  let(:subject) { Typekit::Record::Kit.new client, id: 'xxx' }

  options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

  it 'deletes the record', options do
    expect(subject.delete).to be true
  end
end
