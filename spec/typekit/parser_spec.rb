require 'spec_helper'
require 'typekit'

describe Typekit::Parser do
  def create(format)
    Typekit::Parser.build(format)
  end

  it 'supports JSON' do
    subject = create(:json)
    result = subject.process('{ "kits": [] }')
    expect(result).to eq("kits" => [])
  end

  it 'supports YAML' do
    subject = create(:yaml)
    result = subject.process("---\nkits: []")
    expect(result).to eq("kits" => [])
  end

  it 'does not support XML' do
    expect { create(:xml) }.to \
      raise_error(Typekit::Parser::Error, /Unknown format/i)
  end
end
