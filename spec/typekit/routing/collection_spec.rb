require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Collection do
  def create(name = nil, parent = nil, **options)
    collection = Typekit::Routing::Collection.new(name, **options)
    parent.append(collection) if parent
    collection
  end

  def create_tree(*path)
    root = create
    leaf = path.inject(root) { |parent, name| create(name, parent) }
    [ root, leaf ]
  end

  def double_request(action = :index)
    double('Request', :<< => nil, :action => action)
  end

  describe '#find' do
    it 'looks up nested Collections' do
      root, families = create_tree(:kits, :families)
      expect(root.find(:kits, :families)).to eq(families)
    end

    it 'returns the root when no arguments are given' do
      root, _ = create_tree(:kits, :families)
      expect(root.find).to eq(root)
    end
  end

  describe '#trace' do
    it 'returns paths of Collections' do
      _, families = create_tree(:kits, :families)
      expect(families.trace).to eq([ :kits, :families ])
    end
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
      kits = create(:kits, only: :index)
      expect { kits.assemble(double_request(:show), 'xxx') }.to \
        raise_error(Typekit::RoutingError, /Not permitted/i)
    end
  end
end
