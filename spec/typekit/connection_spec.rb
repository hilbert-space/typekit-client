require 'spec_helper'
require 'typekit'

describe Typekit::Connection do
  HTTP_METHODS = [ :get, :post, :delete ]

  let(:token) { 'arbitrary' }
  let(:subject) { Typekit::Connection.new token: token }

  it 'has the HTTP methods supported by Typekit' do
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
        subject.send method, 'https://typekit.com/api'
      end

      it 'passes ordinary parameters' do
        queries = [
          'name=Megakit&domains=localhost',
          'domains=localhost&name=Megakit'
        ]
        expect(klass).to receive(:new).
          with{ |uri| queries.include? uri.query }.and_call_original
        subject.send method, 'https://typekit.com/api',
          { name: 'Megakit', domains: 'localhost' }
      end

      it 'passes parameters whose values are ordinary lists' do
        query = 'domains[]=example.com&domains[]=example.net'
        expect(klass).to receive(:new).
          with{ |uri| uri.query == query }.and_call_original
        subject.send method, 'https://typekit.com/api',
          { domains: [ 'example.com', 'example.net' ] }
      end

      it 'passes parameters whose values are object lists' do
        queries = [
          'families[0][id]=gkmg&families[1][id]=asdf',
          'families[1][id]=asdf&families[0][id]=gkmg'
        ]
        expect(klass).to receive(:new).
          with{ |uri| queries.include? uri.query }.and_call_original
        subject.send method, 'https://typekit.com/api',
          { families: { 0 => { id: 'gkmg' }, 1 => { id: 'asdf' } } }
      end

      it 'passes integers as decimal strings' do
        expect(klass).to receive(:new).
          with{ |uri| uri.query == 'page=42' }.and_call_original
        subject.send method, 'https://typekit.com/api', { page: 42 }
      end

      it 'passes integers in object lists as decimal strings' do
        queries = [
          'primes[0][value]=2&primes[1][value]=3',
          'primes[1][value]=3&primes[0][value]=2'
        ]
        expect(klass).to receive(:new).
          with{ |uri| queries.include? uri.query }.and_call_original
        subject.send method, 'https://typekit.com/api',
          { primes: { 0 => { value: 2 }, 1 => { value: 3 } } }
      end

      it 'passes the logical true as the string true' do
        expect(klass).to receive(:new).
          with{ |uri| uri.query == 'badge=true' }.and_call_original
        subject.send method, 'https://typekit.com/api', { badge: true }
      end

      it 'passes the logical false as the string false' do
        expect(klass).to receive(:new).
          with{ |uri| uri.query == 'badge=false' }.and_call_original
        subject.send method, 'https://typekit.com/api', { badge: false }
      end
    end
  end
end
