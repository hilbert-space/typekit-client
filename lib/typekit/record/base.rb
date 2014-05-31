require 'forwardable'

module Typekit
  module Record
    class Base
      extend Forwardable

      attr_reader :attributes
      def_delegator :attributes, :to_json

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

