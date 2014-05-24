require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Node do
  let(:subject_class) { Typekit::Routing::Node }

  def create_tree(*path)
    root = subject_class.new
    leaf = path.inject(root) do |parent, name|
      node = subject_class.new(name)
      parent.append(node)
      node
    end
    [ root, leaf ]
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
    it 'returns routes of Collections' do
      _, families = create_tree(:kits, :families)
      expect(families.trace).to eq([ :kits, :families ])
    end
  end
end
