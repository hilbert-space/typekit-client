module Typekit
  module Record
    class Base
      attr_reader :attributes, :raw_attributes

      def initialize(attributes = {})
        @attributes = self.class.filter_attributes(attributes)
        @raw_attributes = attributes.freeze
      end

      def self.attributes
        @attributes ||= []
      end

      def self.attribute?(name)
        attributes.include?(name)
      end

      def self.has_attributes(*names)
        attributes.push(*(names - attributes))
      end

      def self.filter_attributes(assignments)
        Hash[
          (attributes & assignments.keys).map do |name|
            [ name, assignments[name] ]
          end
        ]
      end

      def method_missing(name, *arguments)
        if name.to_s =~ /^(?<name>.*)=$/
          name = Regexp.last_match(:name).to_sym
          return super unless self.class.attribute?(name)
          @attributes.send(:[]=, name, *arguments)
        else
          return super unless self.class.attribute?(name)
          @attributes.send(:[], name, *arguments)
        end
      end
    end
  end
end

