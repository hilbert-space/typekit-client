require_relative 'configuration/base'
require_relative 'configuration/default'

module Typekit
  module Configuration
    Error = Class.new(Typekit::Error)

    def self.build(spec, **options)
      self.const_get(spec.to_s.capitalize).new(**options)
    rescue NameError
      raise Error, 'Unknown specification'
    rescue ArgumentError => e
      raise Error, 'Not enough arguments'
    end
  end
end
