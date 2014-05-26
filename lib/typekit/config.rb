require_relative 'config/base'
require_relative 'config/default'

module Typekit
  module Config
    Error = Class.new(Typekit::Error)

    @address = 'https://typekit.com/api'.freeze

    @actions = [ :index, :show, :create, :update, :delete ].freeze
    @collection_actions = [ :index, :create ].freeze
    @member_actions = [ :show, :update, :delete ].freeze
    @action_dictionary = { :index => :get, :show => :get,
      :create => :post, :update => :post, :delete => :delete }.freeze

    singleton_class.class_eval do
      attr_reader :address, :actions, :collection_actions,
        :member_actions, :action_dictionary
    end

    def self.build(name, **options)
      self.const_get(name.to_s.capitalize).new(**options)
    rescue NameError
      raise Error, 'Unknown configuration'
    rescue ArgumentError => e
      raise Error, 'Not enough arguments'
    end
  end
end
