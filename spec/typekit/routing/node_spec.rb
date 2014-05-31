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

    shared_examples 'adequate assembler' do
      let(:request) { create_request(action) }

      it 'builds up Requests' do
        expect(request).to receive(:<<).
          exactly(path.size).times.and_call_original
        root.assemble(request, path)
      end

      it 'signs Requests' do
        expect(request).to receive(:sign).
          with(satisfy { |n| n.match(:families) })
        root.assemble(request, path)
      end
    end

    restful_collection_actions.each do |action|
      context "when tracing #{ action } actions" do
        let(:action) { action }
        let(:path) { [ :kits, 'xxx', :families ] }

        it_behaves_like 'adequate assembler'
      end
    end

    restful_member_actions.each do |action|
      context "when tracing #{ action } actions" do
        let(:action) { action }
        let(:path) { [ :kits, 'xxx', :families, 'yyy' ] }

        it_behaves_like 'adequate assembler'
      end
    end
  end
end
