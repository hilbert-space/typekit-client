require 'spec_helper'
require 'typekit'

describe Typekit::Client do
  RESTFULL_METHODS = [ :get, :post, :delete ]

  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Client.new token: token }

  it 'has the RESTfull methods supported by Typekit' do
    RESTFULL_METHODS.each do |method|
      expect(subject).to respond_to(method)
    end
  end
end
