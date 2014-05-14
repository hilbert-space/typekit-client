require 'spec_helper'
require 'typekit'

describe Typekit::Router do
  describe '#locate' do
    it 'constructs RESTfull URIs' do
      router = Typekit::Router.new version: 1, format: :json
      expect(router.locate :kits).to include('kits')
      expect(router.locate [ :kits, 'xyz', :published ]).to \
        include('kits/xyz/published')
    end

    it 'takes into account the version of the API' do
      router = Typekit::Router.new version: 42, format: :json
      expect(router.locate :kits).to include('v42')
    end

    it 'takes into account the data format' do
      [ :json, :yaml, :xml ].each do |format|
        router = Typekit::Router.new version: 1, format: format
        expect(router.locate :kits).to include(format.to_s)
      end
    end
  end
end
