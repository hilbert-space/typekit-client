module Typekit
  module Parser
    module JSON
      def self.extended base
        require 'json'
      rescue LoadError
        raise LoadError, 'The JSON parser cannot be loaded.'
      end

      def parse data
        ::JSON.parse data
      end
    end

    module YAML
      def self.extended base
        require 'yaml'
      rescue LoadError
        raise LoadError, 'The YAML parser cannot be loaded.'
      end

      def parse data
        ::YAML.load data
      end
    end
  end
end
