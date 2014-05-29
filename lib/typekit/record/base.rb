module Typekit
  module Record
    class Base
      def initialize(options = {})
        (self.class.attributes & options.keys).each do |key|
          instance_variable_set("@#{ key }", options[key])
        end
      end

      def self.has_attributes(*names)
        attributes.push(*names)
        attr_reader *names
      end

      def self.attributes
        @attributes ||= []
      end

      def self.has_many(name)
      end
    end
  end
end

