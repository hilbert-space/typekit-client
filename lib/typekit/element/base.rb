module Typekit
  module Element
    class Base
      extend Forwardable

      include Client::Proxy

      attr_reader :attributes
      def_delegators :attributes, :to_hash, :to_h, :to_json

      def initialize(*arguments)
        @attributes = Helper.symbolize_keys(Helper.extract_hash!(arguments))
        connect(arguments.first)
      end

      def become(another)
        raise ArgumentError, 'Invalid class' unless self.class == another.class
        @attributes = another.attributes
        true
      end

      def self.feature?(name)
        name = Helper.constantize(name)
        @features ||= {}
        return @features[name] if @features.key?(name)
        @features[name] = include?(Element.const_get(name))
      end

      def feature?(name)
        self.class.feature?(name)
      end

      def attribute?(name)
        attributes.key?(name)
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
