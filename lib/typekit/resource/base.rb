module Typekit
  module Resource
    class Base
      def initialize(options = {})
        options = Hash[options.map { |k, v| [ k.to_sym, v ] }]
        (self.class.attributes & options.keys).each do |key|
          instance_variable_set "@#{ key }", options[key]
        end
      end

      def self.define_attributes(*names)
        @attributes ||= []
        new_names = names.map(&:to_sym) - @attributes
        @attributes.push(*new_names)
        attr_reader *new_names
      end

      def self.attributes *arguments
        @attributes ? @attributes.clone : []
      end
    end
  end
end

