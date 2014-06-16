require 'spec_helper'

RSpec.describe 'Resource::Kit#update and #save' do
  let(:client) { Typekit::Client.new(token: 'arbitrary') }
  let(:subject_class) { client::Kit }

  subject do
    subject_class.new(id: 'xxx', name: 'Megakit', domains: 'localhost')
  end

  before(:example) do
    subject.persistent!
  end

  context 'when successful' do
    options = { vcr: { cassette_name: 'update_kits_ok' } }

    it 'updates the Kit', options do
      subject.name = 'Ultrakit'
      expect(subject.save).to be true
    end

    it 'takes changed attributes into account', options do
      subject.name = 'Ultrakit'
      subject.save
      expect(subject.name).to eq('Ultrakit')
    end
  end
end
