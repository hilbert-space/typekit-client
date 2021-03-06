module Typekit
  module Element
    class Base
      extend Forwardable

      include Client::Proxy

      attr_reader :attributes
      def_delegators :attributes, :to_hash, :to_h, :to_json

      def initialize(*arguments)
        @attributes = prepare_attributes(Helper.extract_hash!(arguments))
        @attributes[:id] = nil unless @attributes.key?(:id)
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

      def assign_attributes(*arguments)
        prepare_attributes(*arguments).each do |name, value|
          attributes[name] = value
        end
      end

      private

      def prepare_attributes(attributes)
        Helper.symbolize_keys(attributes)
      end

      def method_missing(name, *arguments)
        if name.to_s =~ /^(?<name>.*)=$/
          name = Regexp.last_match(:name).to_sym
          attributes.send(:[]=, name, *arguments)
        else
          return super unless attributes.key?(name)
          attributes[name]
        end
      end
    end
  end
end
