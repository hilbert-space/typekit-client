module Typekit
  module Collection
    class Base
      extend Forwardable
      include Enumerable
      include Query
      include Client::Proxy

      attr_reader :client, :token

      def_delegators :@elements, :to_json, :each, :<=>

      def initialize(name, collection_attributes = [], client: nil)
        @client = client
        @token = Helper.tokenize(name)

        klass = Element.classify(name)
        @elements = collection_attributes.map do |attributes|
          attributes = { id: attributes } unless attributes.is_a?(Hash)
          klass.new(attributes.merge(client: client))
        end
      end
    end
  end
end
