module Typekit
  module Element
    class Base
      include Client::Proxy

      attr_reader :attributes

      def initialize(*arguments)
        @attributes = Helper.symbolize_keys(Helper.extract_hash!(arguments))
        proxy(*arguments)
      end

      def become(another)
        raise ArgumentError, 'Invalid class' unless self.class == another.class
        @attributes = another.attributes
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
