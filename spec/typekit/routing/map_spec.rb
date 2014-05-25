require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  describe '#define' do
    it 'declares new resources' do
      subject.define { resources(:kits) }
      request = subject.request(:index, :kits)
      expect(request.address).to eq('kits')
    end

    it 'declares nested resources' do
      subject.define { resources(:kits) { resources(:families) } }
      request = subject.request(:show, :kits, 'xxx', :families, 'yyy')
      expect(request.address).to eq('kits/xxx/families/yyy')
    end

    it 'declares scoped resources' do
      subject.define do
        scope 'https://typekit.com/api' do
          scope [ 'version', 1, 'format', :json ] do
            resources(:kits) { resources(:families) }
          end
        end
      end
      request = subject.request(:show, :kits, 'xxx', :families, 'yyy')
      expect(request.address).to eq(
        'https://typekit.com/api/version/1/format/json/kits/xxx/families/yyy')
    end

    it 'declares custom operations' do
      subject.define { resources(:kits) { show(:published, on: :member) } }
      request = subject.request(:show, :kits, 'xxx', :published)
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
      request = subject.request(:show, :kits, 'xxx', :families, 'yyy', 'zzz')
      expect(request.address).to eq('kits/xxx/families/yyy/zzz')
    end
  end

  describe '#request' do
    before(:each) do
      subject.define do
        resources :kits do
          resources :families, only: [ :show, :update, :delete ]
          show :published, on: :member
        end
      end
    end

    it 'raises exceptions for unknown resources' do
      expect { subject.request(:show, :kittens) }.to \
        raise_error(Typekit::Routing::Error, /Not found/i)
    end

    [ :show, :update, :delete ].each do |action|
      it "raises exceptions for #{ action } actions to collections" do
        expect { subject.request(action, :kits) }.to \
          raise_error(Typekit::Routing::Error, /Not permitted/i)
      end
    end

    [ :index, :create ].each do |action|
      it "raises exceptions for #{ action } actions to members" do
        expect { subject.request(action, :kits, 'xxx') }.to \
          raise_error(Typekit::Routing::Error, /Not permitted/i)
      end
    end

    it 'raises exceptions for forbidden actions' do
      expect { subject.request(:index, :kits, 'xxx', :families) }.to \
        raise_error(Typekit::Routing::Error, /Not permitted/i)
    end
  end
end
