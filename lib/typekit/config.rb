module Typekit
  module Config
    @address = 'https://typekit.com/api'.freeze
    @actions = [ :index, :show, :update, :delete ].freeze

    singleton_class.class_eval do
      attr_reader :address, :actions
    end
  end
end
