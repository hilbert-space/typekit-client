module Typekit
  module Record
    class Base
      def initialize(options = {})
        (self.class.attributes & options.keys).each do |key|
          instance_variable_set("@#{ key }", options[key])
        end
      end

      def self.attributes(*names)
        @attributes ||= []
        unless names.empty?
          @attributes.push(*names)
          attr_reader *names
        end
        @attributes
      end
    end
  end
end

