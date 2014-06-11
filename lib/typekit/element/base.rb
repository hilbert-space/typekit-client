module Typekit
  module Element
    class Base
      extend Forwardable
      extend Association

      include Persistence
      include Client::Proxy

      extend Query
      extend Client::Proxy

      attr_reader :attributes
      def_delegator :attributes, :to_json

      def initialize(attributes = {})
        proxy(attributes.delete(:client)) if attributes.key?(:client)
        @attributes = Helper.symbolize_keys(attributes)
      end

      private

      def method_missing(name, *arguments)
        if name.to_s =~ /^(?<name>.*)=$/
          name = Regexp.last_match(:name).to_sym
          return super unless attributes.key?(name)
          attributes[name] = arguments.first
        else
          return super unless attributes.key?(name)
          attributes[name]
        end
      end
    end
  end
end
