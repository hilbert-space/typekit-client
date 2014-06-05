require 'forwardable'

module Typekit
  module Record
    class Base
      extend Forwardable

      attr_reader :attributes
      def_delegator :attributes, :to_json

      def self.has_many(name)
        associations << name

        define_method(name) do
          v = "@#{ name }"
          return instance_variable_get(v) if instance_variable_defined?(v)

          if attributes.key?(name)
            klass = Record.classify(name)
            members = attributes[name].map do |member_attributes|
              klass.new(member_attributes)
            end
          else
            members = []
          end

          instance_variable_set(v, members)
        end
      end

      def self.associations
        @associations ||= []
      end

      def initialize(attributes = {})
        @attributes = Hash[attributes.map { |k, v| [ k.to_sym, v ] }]
      end

      def method_missing(name, *arguments)
        if name.to_s =~ /^(?<name>.*)=$/
          name = Regexp.last_match(:name).to_sym
          return super unless arguments.length == 1
          return super unless @attributes.key?(name)
          @attributes[name] = arguments.first
        else
          return super unless arguments.length.zero?
          return super unless @attributes.key?(name)
          @attributes[name]
        end
      end
    end
  end
end

