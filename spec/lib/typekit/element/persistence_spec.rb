require 'spec_helper'
require 'fixture/record/article'

RSpec.describe Typekit::Element::Persistence do
  let(:article_class) { Fixture::Record::Article }
  let(:client) { double }

  subject { article_class.new(client, id: 69) }

  describe '#new?' do
    it 'returns true for new records' do
      expect(subject).to be_new
    end

    it 'returns false for persistent records' do
      subject.persistent!
      expect(subject).not_to be_new
    end
  end

  describe '#persistent?' do
    it 'returns true for persistent records' do
      subject.persistent!
      expect(subject).to be_persistent
    end

    it 'returns false for new records' do
      expect(subject).not_to be_persistent
    end

    it 'returns false for deleted records' do
      allow(client).to receive(:process).and_return(true)
      subject.persistent!
      subject.delete
      expect(subject).not_to be_persistent
    end
  end

  describe '#persistent!' do
    it 'marks records as persistent' do
      expect { subject.persistent! }.to \
        change { subject.persistent? }.from(false).to(true)
    end
  end

  describe '#save' do
    context 'when successful' do
      before(:example) do
        allow(client).to receive(:process).and_return(article_class.new)
      end

      it 'returns true' do
        expect(subject.save).to be true
      end

      it 'marks records as not new' do
        expect { subject.save }.to \
          change { subject.new? }.from(true).to(false)
      end

      it 'marks records as persistent' do
        expect { subject.save }.to \
          change { subject.persistent? }.from(false).to(true)
      end
    end

    context 'when unsuccessful' do
      before(:example) do
        allow(client).to \
          receive(:process).and_raise(Typekit::ServerError.new(404))
      end

      it 'returns false' do
        expect(subject.save).to be false
      end
    end
  end

  describe '#delete' do
    context 'when successful' do
      it 'deletes and markes as deleted if not new' do
        subject.persistent!
        allow(client).to receive(:process).and_return(true)

        expect(subject).not_to be_deleted
        expect(subject.delete).to be true
        expect(subject).to be_deleted
      end

      it 'markes as deleted if new' do
        expect(subject).not_to be_deleted
        expect(subject.delete).to be true
        expect(subject).to be_deleted
      end
    end
  end
end
