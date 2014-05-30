require 'yaml'

module Typekit
  module Processing
    module Parser
      class YAML
        def process(data)
          ::YAML.load(data)
        rescue
          raise Error, 'Unable to parse'
        end
      end
    end
  end
end
