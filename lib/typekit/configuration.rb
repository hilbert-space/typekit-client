require_relative 'configuration/base'
require_relative 'configuration/default'

module Typekit
  module Configuration
    Error = Class.new(Typekit::Error)

    def self.build(config, **options)
      self.const_get(config.to_s.capitalize).new(**options)
    rescue NameError
      raise Error, 'Unknown configuration'
    rescue ArgumentError => e
      raise Error, 'Not enough arguments'
    end
  end
end
