require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  extend RESTHelper

  def create_request(action)
    # TODO: mock?
    Typekit::Request.new(action: action)
  end

  describe '#define' do
    it 'declares new resources' do
      subject.define { resources(:kits) }
      request = subject.trace(create_request(:index), :kits)
      expect(request.address).to eq('kits')
    end

    it 'declares nested resources' do
      subject.define { resources(:kits) { resources(:families) } }
      request = subject.trace(create_request(:show),
        :kits, 'xxx', :families, 'yyy')
      expect(request.address).to eq('kits/xxx/families/yyy')
    end

    it 'declares scoped resources' do
      subject.define do
        scope 'https://typekit.com/api' do
          scope [ 'v1', :json ] do
            resources(:kits) { resources(:families) }
          end
        end
      end
      request = subject.trace(create_request(:show),
        :kits, 'xxx', :families, 'yyy')
      expect(request.address).to eq(
        'https://typekit.com/api/v1/json/kits/xxx/families/yyy')
    end

    it 'declares custom operations' do
      subject.define { resources(:kits) { show(:published, on: :member) } }
      request = subject.trace(create_request(:show),
        :kits, 'xxx', :published)
      expect(request.address).to eq('kits/xxx/published')
    end

    it 'declares custom operations with variable names' do
      subject.define do
        resources :kits do
          resources :families do
            show ':variant', on: :member
          end
        end
      end
      request = subject.trace(create_request(:show),
        :kits, 'xxx', :families, 'yyy', 'zzz')
      expect(request.address).to eq('kits/xxx/families/yyy/zzz')
    end
  end

  describe '#trace' do
    before(:each) do
      subject.define do
        resources :families, only: :show
        resources :kits do
          resources :families, only: [ :show, :update, :delete ]
          show :published, on: :member
        end
      end
    end

    restful_member_actions.each do |action|
      it "assembles addresses of #{ action } Requests" do
        request = subject.trace(create_request(action), :kits, 'xxx')
        expect(request.address).to eq('kits/xxx')
      end
    end

    restful_collection_actions.each do |action|
      it "assembles addresses of #{ action } Requests" do
        request = subject.trace(create_request(action), :kits)
        expect(request.address).to eq('kits')
      end
    end

    restful_member_actions.each do |action|
      it "raises exceptions for #{ action } actions to collections" do
        expect { subject.trace(create_request(action), :kits) }.to \
          raise_error(Typekit::Routing::Error, /Not permitted/i)
      end
    end

    restful_collection_actions.each do |action|
      it "raises exceptions for #{ action } actions to members" do
        expect { subject.trace(create_request(action), :kits, 'xxx') }.to \
          raise_error(Typekit::Routing::Error, /Not permitted/i)
      end
    end

    it 'raises exceptions for forbidden actions' do
      expect do
        subject.trace(create_request(:index), :kits, 'xxx', :families)
      end.to raise_error(Typekit::Routing::Error, /Not permitted/i)
    end
  end
end
