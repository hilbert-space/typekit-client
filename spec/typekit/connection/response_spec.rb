require 'spec_helper'
require 'typekit'

describe Typekit::Connection::Response do
  let(:subject_class) { Typekit::Connection::Response }

  def create(code: 200, body: '')
    subject_class.new(code: code, body: body)
  end

  it 'is considered to be successful for HTTP OK' do
    expect(create(code: 200)).to be_success
  end

  it 'is considered to be successful for HTTP Found' do
    expect(create(code: 302)).to be_success
  end
end
