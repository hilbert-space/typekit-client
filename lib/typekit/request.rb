require 'forwardable'

module Typekit
  class Request
    extend Forwardable

    attr_reader :action, :path
    def_delegators :@path, :<<

    def initialize(action:)
      @action = action
      @path = []
    end

    def address
      # TODO: cache?
      @path.map(&:to_s).join('/')
    end
  end
end
