require 'forwardable'

module Typekit
  class Request
    extend Forwardable

    attr_reader :action, :trace
    def_delegators :@trace, :<<

    def initialize(action:)
      @action = action
      @trace = []
    end

    def address
      # TODO: cache?
      @trace.map(&:to_s).join('/')
    end
  end
end
