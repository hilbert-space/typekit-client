require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  extend RESTHelper

  def create_request(action)
    # TODO: mock?
    Typekit::Connection::Request.new(action: action)
  end

  describe '#define' do
    it 'declares new resources' do
      subject.define { resources(:kits) }
      request = subject.trace(create_request(:index), [ :kits ])
      expect(request.address).to eq('kits')
    end

    it 'declares nested resources' do
      subject.define { resources(:kits) { resources(:families) } }
      request = subject.trace(create_request(:show),
        [ :kits, 'xxx', :families, 'yyy' ])
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
        [ :kits, 'xxx', :families, 'yyy' ])
      expect(request.address).to eq(
        'https://typekit.com/api/v1/json/kits/xxx/families/yyy')
    end

    it 'declares custom operations' do
      subject.define { resources(:kits) { show(:published, on: :member) } }
      request = subject.trace(create_request(:show),
        [ :kits, 'xxx', :published ])
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
        [ :kits, 'xxx', :families, 'yyy', 'zzz' ])
      expect(request.address).to eq('kits/xxx/families/yyy/zzz')
    end
  end

  describe '#trace' do
    shared_examples 'adequate resource tracer' do
      restful_member_actions.each do |action|
        it "assembles addresses of #{ action } Requests" do
          request = subject.trace(create_request(action),
            [ *subject_path, 'xxx' ])
          expect(request.address).to eq("#{ subject_address }/xxx")
        end
      end

      restful_collection_actions.each do |action|
        it "assembles addresses of #{ action } Requests" do
          request = subject.trace(create_request(action), subject_path)
          expect(request.address).to eq(subject_address)
        end
      end

      restful_member_actions.each do |action|
        it "raises exceptions for #{ action } actions to collections" do
          expect do
            subject.trace(create_request(action), subject_path)
          end.to raise_error(Typekit::Routing::Error, /Not permitted/i)
        end
      end

      restful_collection_actions.each do |action|
        it "raises exceptions for #{ action } actions to members" do
          expect do
            subject.trace(create_request(action), [ *subject_path, 'xxx' ])
          end.to raise_error(Typekit::Routing::Error, /Not permitted/i)
        end
      end
    end

    context 'when working with plain collections' do
      before(:each) do
        subject.define { resources(:kits) }
      end

      let(:subject_path) { [ :kits ] }
      let(:subject_address) { 'kits' }

      it_behaves_like 'adequate resource tracer'
    end

    context 'when working with nested collections' do
      before(:each) do
        subject.define do
          resources :kits do
            resources :families
          end
        end
      end

      let(:subject_path) { [ :kits, 'yyy', :families ] }
      let(:subject_address) { 'kits/yyy/families' }

      it_behaves_like 'adequate resource tracer'
    end

    FAMILY_ACTIONS = [ :show, :update, :delete ]

    context "when only #{ FAMILY_ACTIONS.join(', ') } are allowed" do
      before(:each) do
        subject.define do
          resources :kits do
            resources :families, only: FAMILY_ACTIONS
          end
        end
      end

      (restful_collection_actions - FAMILY_ACTIONS).each do |action|
        it "raises expections for #{ action } actions" do
          expect do
            subject.trace(create_request(action),
              [ :kits, 'xxx', :families ])
          end.to raise_error(Typekit::Routing::Error, /Not permitted/i)
        end
      end

      (restful_member_actions - FAMILY_ACTIONS).each do |action|
        it "raises expections for #{ action } actions" do
          expect do
            subject.trace(create_request(action),
              [ :kits, 'xxx', :families, 'yyy' ])
          end.to raise_error(Typekit::Routing::Error, /Not permitted/i)
        end
      end
    end

    restful_actions.each do |action|
      it "assembles addresses for custom #{ action } actions" do
        subject.define do
          resources :kits do
            send(action, :havefun, on: :member)
          end
        end
        request = subject.trace(create_request(action),
          [ :kits, 'xxx', :havefun ])
        expect(request.address).to eq('kits/xxx/havefun')
      end
    end

    it 'does not support reopening of resource declarations' do
      subject.define do
        resources :kits
        resources :kits do
          resources :families
        end
      end
      expect do
        subject.trace(create_request(:show),
          [ :kits, 'xxx', :families, 'yyy' ])
      end.to raise_error(Typekit::Routing::Error, /Not found/i)
    end
  end
end
