require 'forwardable'

module Typekit
  module Record
    class Base
      extend Forwardable

      attr_reader :attributes, :raw_attributes
      def_delegator :attributes, :to_json

      def initialize(attributes = {})
        attributes = Hash[attributes.map { |k, v| [ k.to_sym, v ] }]
        @attributes = self.class.filter_attributes(attributes)
        @raw_attributes = attributes.freeze
      end

      def self.attributes
        @attributes ||= []
      end

      def self.has_attributes(*names)
        names = names - attributes
        attributes.push(*names)
        names.each do |name|
          define_method(name) { @attributes[name] }
          define_method("#{ name }=") { |value| @attributes[name] = value }
        end
      end

      def self.filter_attributes(assignments)
        Hash[
          (attributes & assignments.keys).map do |name|
            [ name, assignments[name] ]
          end
        ]
      end
    end
  end
end

