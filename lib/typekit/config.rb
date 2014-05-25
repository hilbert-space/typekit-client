require_relative 'config/base'
require_relative 'config/default'

module Typekit
  module Config
    Error = Class.new(Typekit::Error)

    @address = 'https://typekit.com/api'.freeze
    @actions = [ :index, :show, :update, :delete ].freeze

    singleton_class.class_eval do
      attr_reader :address, :actions
    end

    def self.build(name, **options)
      self.const_get(name.to_s.capitalize).new(**options)
    rescue NameError
      raise Error, 'Not found'
    rescue ArgumentError => e
      raise Error, 'Not enough arguments'
    end
  end
end
