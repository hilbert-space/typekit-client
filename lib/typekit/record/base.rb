module Typekit
  module Record
    class Base
      extend Forwardable

      attr_reader :client, :attributes
      def_delegator :attributes, :to_json

      def self.has_many(name)
        possessions << name
      end

      def self.possessions
        @possessions ||= []
      end

      def self.belongs_to(name)
        owners << name
      end

      def self.owners
        @owners ||= []
      end

      def initialize(*arguments)
        attributes = arguments.last.is_a?(Hash) ? arguments.pop : {}
        @client = arguments.first

        attributes = { id: attributes } unless attributes.is_a?(Hash)
        @attributes = Helper.symbolize_keys(attributes)

        self.class.possessions.each do |name|
          next unless @attributes.key?(name)
          @attributes[name] = Collection.new(name, @attributes[name])
        end

        self.class.owners.each do |name|
          next unless @attributes.key?(name)
          @attributes[name] = Record.build(name, @attributes[name])
        end
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
          attributes.send(:[]=, name, *arguments)
        else
          return super unless attributes.key?(name)
          attributes.send(:[], name, *arguments)
        end
      end
    end
  end
end
