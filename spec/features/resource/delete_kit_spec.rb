require 'spec_helper'

RSpec.describe 'Resource::Kit#delete' do
  let(:client) { Typekit::Client.new(token: token) }
  let(:subject) { Typekit::Resource::Kit.new(client, id: 'xxx') }

  context 'when successful' do
    options = { vcr: { cassette_name: 'delete_kits_xxx_ok' } }

    it 'deletes the Kit', options do
      expect(subject.delete).to be true
    end

    it 'marked the Kit as deleted', options do
      subject.delete
      expect(subject.deleted?).to be true
    end

    it 'does not try to delete the Kit a second time', options do
      allow(client).to receive(:process).and_call_original
      subject.delete
      subject.delete
      expect(client).to have_received(:process).once
    end
  end

  context 'when not found' do
    options = { vcr: { cassette_name: 'delete_kits_xxx_not_found' } }

    it 'raises an exception', options do
      expect { subject.delete }.to raise_error(Typekit::Error, /Not found/i)
    end
  end
end
