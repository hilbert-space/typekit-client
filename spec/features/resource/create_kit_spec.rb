require 'spec_helper'

RSpec.describe 'Resource::Kit#new and #save' do
  let(:client) { Typekit::Client.new(token: token) }
  let(:subject_class) { client::Kit }

  context 'when successful' do
    subject { subject_class.new(name: 'Megakit', domains: 'localhost') }

    options = { vcr: { cassette_name: 'create_kits_ok' } }

    it 'creates a new Kit', options do
      expect(subject.save).to be true
    end

    it 'takes attributes into account', options do
      subject.save
      expect(subject.name).to eq('Megakit')
    end
  end
end
