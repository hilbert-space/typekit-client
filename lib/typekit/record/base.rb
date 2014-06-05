module Typekit
  module Record
    class Base
      extend Forwardable

      attr_reader :attributes
      def_delegator :attributes, :to_json

      def self.has_many(name)
        collections << name
      end

      def self.collections
        @collections ||= []
      end

      def initialize(attributes = {})
        @attributes = Hash[attributes.map { |k, v| [ k.to_sym, v ] }]
        self.class.collections.each do |name|
          @attributes[name] = Collection.new(name, @attributes[name] || [])
        end
      end

      def method_missing(name, *arguments)
        if name.to_s =~ /^(?<name>.*)=$/
          name = Regexp.last_match(:name).to_sym
          return super unless @attributes.key?(name)
          @attributes[name] = arguments.first
        else
          return super unless @attributes.key?(name)
          @attributes[name]
        end
      end
    end
  end
end

