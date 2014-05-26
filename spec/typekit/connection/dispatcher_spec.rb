require 'spec_helper'
require 'typekit'

describe Typekit::Connection::Dispatcher do
  extend RESTHelper

  let(:token) { 'arbitrary' }
  let(:address) { 'https://typekit.com/api/v1/json/kits' }
  let(:subject) { Typekit::Connection::Dispatcher.new(token: token) }

  def create_request(action)
    double('Request', action: action, address: address, parameters: {})
  end

  describe '#deliver' do
    restful_actions.each do |action|
      method = rest_http_dictionary[action]

      context "when sending #{ action } Requests" do
        it 'sets the token header' do
          stub = stub_http_request(method, address)
          response = subject.deliver(create_request(action))
          expect(stub).to have_requested(method, address).
            with(:headers => { 'X-Typekit-Token' => token })
        end

        it 'returns Responses' do
          stub_http_request(method, address).
            to_return(status: 200, body: 'Hej!')
          response = subject.deliver(create_request(action))
          expect([ response.code, response.content ]).to eq([ 200, 'Hej!' ])
        end
      end
    end
  end
end
