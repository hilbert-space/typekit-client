module Typekit
  module Record
    class Base
      extend Forwardable
      extend Association

      attr_reader :client, :attributes
      def_delegator :attributes, :to_json

      def initialize(*arguments)
        attributes = Helper.extract_options!(arguments)
        @client = arguments.first

        attributes = { id: attributes } unless attributes.is_a?(Hash)
        @attributes = Helper.symbolize_keys(attributes)
      end

      def delete
        process(:delete, id)
      end
      alias_method :destroy, :delete

      private

      def process(action, *arguments)
        raise Error, 'Client is not given' unless client
        client.process(action, Helper.tokenize(self.class), *arguments)
      end

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
