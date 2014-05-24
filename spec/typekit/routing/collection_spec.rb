require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Collection do
  let(:subject_class) { Typekit::Routing::Collection }

  def create_tree(*path)
    root = subject_class.new
    leaf = path.inject(root) do |parent, name|
      collection = subject_class.new(name)
      parent.append(collection)
      collection
    end
    [ root, leaf ]
  end

  def double_request(action = :index)
    double('Request', :<< => nil, :action => action)
  end

  describe '#assemble' do
    it 'builds up index Requests' do
      root, _ = create_tree(:kits, :families)
      request = double_request(:index)
      root.assemble(request, :kits, 'xxx', :families)
      expect(request).to have_received(:<<).exactly(3).times
    end

    it 'builds up show Requests' do
      root, _ = create_tree(:kits, :families)
      request = double_request(:show)
      root.assemble(request, :kits, 'xxx', :families, 'yyy')
      expect(request).to have_received(:<<).exactly(4).times
    end

    it 'raises exceptions when encounters forbidden actions' do
      kits = subject_class.new(:kits, only: :index)
      expect { kits.assemble(double_request(:show), 'xxx') }.to \
        raise_error(Typekit::RoutingError, /Not permitted/i)
    end
  end
end
