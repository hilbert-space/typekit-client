require_relative 'config/base'
require_relative 'config/default'

module Typekit
  module Config
    Error = Class.new(Typekit::Error)

    def self.build(name, **options)
      self.const_get(name.to_s.capitalize).new(**options)
    rescue NameError
      raise Error, 'Unknown configuration'
    rescue ArgumentError => e
      raise Error, 'Not enough arguments'
    end
  end
end
