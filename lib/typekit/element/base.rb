module Typekit
  module Element
    class Base
      def initialize(options = {})
        (self.class.attributes & options.keys).each do |key|
          instance_variable_set("@#{ key }", options[key])
        end
      end

      def self.define_attributes(*names)
        attributes.push(*names)
        attr_reader *names
      end

      def self.attributes
        @attributes ||= []
      end
    end
  end
end

