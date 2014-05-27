require_relative 'adaptor/standard'

module Typekit
  module Connection
    module Adaptor
      def self.build(name)
        self.const_get(name.to_s.capitalize).new
      rescue NameError
        raise Error, 'Unknown connection adaptor'
      end
    end
  end
end
