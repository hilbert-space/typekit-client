require 'spec_helper'
require 'typekit'

describe Typekit::Processor do
  it 'supports JSON' do
    parser = Typekit::Processor.new format: :json
    response = double success?: true, content: '{ "a": 1 }'
    result = parser.process response
    expect(result).to eq({ "a" => 1 })
  end

  it 'supports YAML' do
    parser = Typekit::Processor.new format: :yaml
    response = double success?: true, content: "---\na: 1"
    result = parser.process response
    expect(result).to eq({ "a" => 1 })
  end

  it 'does not support XML' do
    expect{ Typekit::Processor.new format: :xml }.to raise_error
  end

  it 'raises an appropriate exception when a request fails' do
    parser = Typekit::Processor.new format: :json
    response = double success?: false, code: 401,
      content: '{ "errors": [ "Not authorized" ] }'
    expect{ parser.process response }.to \
      raise_error(Typekit::Error, 'Not authorized')
  end
end
