require_relative 'parser/json'
require_relative 'parser/yaml'

module Typekit
  module Processing
    module Parser
      def self.build(format)
        self.const_get(format.to_s.upcase).new
      rescue NameError
        raise Error, 'Unknown format'
      end
    end
  end
end
