require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Node do
  extend RESTHelper

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

  describe 'Base#assemble' do
    let(:root) { create_tree(:kits, :families) }

    restful_collection_actions.each do |action|
      it "builds up #{ action } Requests" do
        request = double('Request', :<< => nil, :action => action,
          :path => [ :kits, 'xxx', :families ])
        root.assemble(request, [ :kits, 'xxx', :families ])
        expect(request).to have_received(:<<).exactly(3).times
      end
    end

    restful_member_actions.each do |action|
      it "builds up #{ action } Requests" do
        request = double('Request', :<< => nil, :action => action,
          :path => [ :kits, 'xxx', :families, 'yyy' ])
        root.assemble(request, [ :kits, 'xxx', :families, 'yyy' ])
        expect(request).to have_received(:<<).exactly(4).times
      end
    end
  end
end
