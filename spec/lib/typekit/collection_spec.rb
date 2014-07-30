require 'fixture/record/article'

RSpec.describe Typekit::Collection do
  let(:article_class) { Fixture::Record::Article }

  describe '.build' do
    subject { described_module.build(:articles, [{ id: 4 }, { id: 2 }]) }

    it 'creates a Collection' do
      expect(subject).to be_an_instance_of(described_module::Base)
    end

    describe 'the Collection' do
      it 'contains Elements' do
        subject.each do |element|
          expect(element).to be_an_instance_of(article_class)
        end
      end
    end
  end
end
