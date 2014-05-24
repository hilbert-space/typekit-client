require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Map do
  describe '#new' do
    it 'forwards given blocks to #define' do
      subject = Typekit::Routing::Map.new { resources(:kits) }
      expect { subject.request(:show, :kits) }.not_to raise_error
    end
  end

  describe '#define' do
    it 'allows to declare new resources' do
      subject.define { resources(:kits) }
      expect { subject.request(:show, :kits) }.not_to raise_error
    end

    it 'allows to declare nested resources' do
      subject.define { resources(:kits) { resources(:families) } }
      expect { subject.request(:show, :kits, 'xxx', :families, 'yyy') }.not_to \
        raise_error
    end
  end

  describe '#request' do
    it 'returns Requests' do
      subject.define { resources(:kits) }
      expect(subject.request(:show, :kits)).to be_kind_of(Typekit::Request)
    end

    it 'raises exceptions when encounters unknown resources' do
      expect { subject.request(:show, :kits) }.to \
        raise_error(Typekit::RoutingError, /Not found/i)
    end
  end
end
