module Typekit
  Error = Class.new(StandardError)

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
end
