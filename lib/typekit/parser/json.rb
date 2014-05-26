require 'json'

module Typekit
  module Parser
    class JSON
      def process(data)
        ::JSON.parse(data)
      rescue
        raise Error, 'Unable to parse'
      end
    end
  end
end
