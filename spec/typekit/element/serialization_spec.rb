require 'spec_helper'
require 'fixture/record/article'
require 'fixture/record/section'

RSpec.describe Typekit::Element::Serialization do
  let(:subject_module) { Typekit::Element }
  let(:subject_class) { Fixture::Record::Article }
  let(:nested_class) { Fixture::Record::Section }

  before(:example) do
    allow(subject_module).to receive(:classify).and_return(nested_class)
    subject_class.has_many(:sections)
  end

  describe '#as_json' do
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
      expect(subject.as_json).to eq(attributes)
    end
  end
end
