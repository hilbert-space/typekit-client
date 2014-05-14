require 'spec_helper'
require 'typekit'

describe Typekit::Connection do
  HTTP_METHODS = [ :get, :post, :delete ]

  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Connection.new token: token }

  it 'the HTTP methods supported by Typekit' do
    HTTP_METHODS.each do |method|
      expect(subject).to respond_to(method)
    end
  end

  before do
    response = double body: '{}', code: '200'
    Net::HTTP.any_instance.stub(:request).and_return(response)
  end

  HTTP_METHODS.each do |method|
    describe "##{ method }" do
      let(:klass) { Net::HTTP::const_get method.to_s.capitalize }

      it 'instantiates an appropriate HTML request' do
        expect(klass).to receive(:new).and_call_original
        subject.send method, 'https://typekit.com/api/bla-bla'
      end
    end
  end
end
