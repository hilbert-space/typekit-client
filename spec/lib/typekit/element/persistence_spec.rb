require 'fixture/record/article'

RSpec.describe Typekit::Element::Persistence do
  let(:article_class) { Fixture::Record::Article }
  let(:client) { double }

  describe '#new?' do
    it 'returns true for new records' do
      subject = article_class.new
      expect(subject).to be_new
    end

    it 'returns false for records with ids' do
      subject = article_class.new(id: 42)
      expect(subject).not_to be_new
    end
  end

  describe '#persistent?' do
    it 'returns true for persistent records' do
      subject = article_class.new(id: 42)
      expect(subject).to be_persistent
    end

    it 'returns false for records without ids' do
      subject = article_class.new
      expect(subject).not_to be_persistent
    end

    it 'returns false for deleted records' do
      subject = article_class.new(client, id: 42)
      allow(client).to receive(:process).and_return(true)

      subject.delete

      expect(subject).not_to be_persistent
    end
  end

  describe '#save' do
    subject { article_class.new(client) }

    context 'when successful' do
      before(:example) do
        allow(client).to \
          receive(:process).and_return(article_class.new(id: 42))
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
      it 'deletes and marks as deleted if not new' do
        subject = article_class.new(client, id: 42)
        allow(client).to receive(:process).and_return(true)

        expect(subject).not_to be_deleted
        expect(subject.delete).to be true
        expect(subject).to be_deleted
      end

      it 'marks as deleted if new' do
        subject = article_class.new

        expect(subject).not_to be_deleted
        expect(subject.delete).to be true
        expect(subject).to be_deleted
      end
    end
  end
end
