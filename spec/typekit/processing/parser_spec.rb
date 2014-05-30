require 'spec_helper'
require 'typekit'

describe Typekit::Processing::Parser do
  let(:subject_class) { Typekit::Processing::Parser }

  it 'supports JSON' do
    subject = subject_class.build(:json)
    result = subject.process('{ "kits": [] }')
    expect(result).to eq("kits" => [])
  end

  it 'supports YAML' do
    subject = subject_class.build(:yaml)
    result = subject.process("---\nkits: []")
    expect(result).to eq("kits" => [])
  end

  it 'does not support XML' do
    expect { subject_class.build(:xml) }.to \
      raise_error(subject_class::Error)
  end
end
