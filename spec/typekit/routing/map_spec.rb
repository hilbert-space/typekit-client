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
        scope [ 'version', 1, 'format', :json ] do
          resources(:kits) { resources(:families) }
        end
      end
      request = subject.request(:show, :kits, 'xxx', :families, 'yyy')
      expect(request.address).to \
        eq('version/1/format/json/kits/xxx/families/yyy')
    end

    it 'declares custom actions' do
      subject.define { resources(:kits) { show(:published, on: :member) } }
      request = subject.request(:show, :kits, 'xxx', :published)
      expect(request.address).to eq('kits/xxx/published')
    end

    it 'declared custom actions with variable names' do
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
    it 'raises exceptions when encounters unknown resources' do
      expect { subject.request(:show, :kittens) }.to \
        raise_error(Typekit::RoutingError, /Not found/i)
    end
  end
end
