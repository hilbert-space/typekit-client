require 'spec_helper'
require 'typekit'

describe Typekit::Routing::Node do
  extend RESTHelper

  def create_request(action)
    # TODO: mock?
    Typekit::Connection::Request.new(action: action)
  end

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
        request = create_request(action)
        expect(request).to receive(:<<).exactly(3).times.and_call_original
        root.assemble(request, [ :kits, 'xxx', :families ])
      end
    end

    restful_member_actions.each do |action|
      it "builds up #{ action } Requests" do
        request = create_request(action)
        expect(request).to receive(:<<).exactly(4).times.and_call_original
        root.assemble(request, [ :kits, 'xxx', :families, 'yyy' ])
      end
    end
  end
end
