require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Node do
  let(:subject_module) { Typekit::Routing::Node }

  def create_tree(*path)
    root = subject_module::Root.new
    path.inject(root) do |parent, name|
      node = subject_module::Collection.new(name)
      parent.append(node)
      node
    end
    root
  end

  def double_request(action = :index)
    double('Request', :<< => nil, :action => action)
  end

  describe 'Base#assemble' do
    it 'builds up index Requests' do
      root = create_tree(:kits, :families)
      request = double_request(:index)
      root.assemble(request, :kits, 'xxx', :families)
      expect(request).to have_received(:<<).exactly(3).times
    end

    it 'builds up show Requests' do
      root = create_tree(:kits, :families)
      request = double_request(:show)
      root.assemble(request, :kits, 'xxx', :families, 'yyy')
      expect(request).to have_received(:<<).exactly(4).times
    end

    it 'raises exceptions when encounters forbidden actions' do
      kits = subject_module::Collection.new(:kits, only: :index)
      expect { kits.assemble(double_request(:show), 'xxx') }.to \
        raise_error(Typekit::Routing::Error, /Not permitted/i)
    end
  end
end
