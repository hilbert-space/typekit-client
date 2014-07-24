require 'spec_helper'
require 'fixture/record/article'
require 'fixture/record/section'

RSpec.describe Typekit::Element::Serialization do
  let(:subject_class) { Fixture::Record::Article }
  let(:nested_class) { Fixture::Record::Section }

  describe '#serialize' do
    let(:attributes) do
      {
        title: 'Conversation',
        sections: [ { content: 'Hello' }, { content: 'Bye' } ]
      }
    end

    subject do
      object = subject_class.new(attributes)
      expect(object.sections.first).to be_kind_of(nested_class)
      object
    end

    it 'returns a Hash' do
      expect(subject.serialize).to eq(attributes)
    end
  end
end
