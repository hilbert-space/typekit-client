require 'spec_helper'
require 'fixture/record/article'
require 'fixture/record/section'

RSpec.describe Typekit::Element::Serialization do
  let(:article_class) { Fixture::Record::Article }
  let(:section_class) { Fixture::Record::Section }

  describe '#serialize' do
    let(:attributes) do
      {
        title: 'Conversation',
        sections: [{ content: 'Hello' }, { content: 'Bye' }]
      }
    end

    subject do
      object = article_class.new(attributes)
      expect(object.sections.first).to be_kind_of(section_class)
      object
    end

    it 'returns a Hash' do
      expect(subject.serialize).to eq(attributes)
    end
  end
end
