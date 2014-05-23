module Typekit
  module Element
    class Base
      def initialize(options = {})
        (self.class.attributes & options.keys).each do |key|
          instance_variable_set("@#{ key }", options[key])
        end
      end

      def self.define_attributes(*attributes)
        (@attributes ||= []).push(*attributes)
        attr_reader *attributes
      end

      def self.attributes
        (@attributes ||= []).clone
      end
    end
  end
end

