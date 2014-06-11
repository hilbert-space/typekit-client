require_relative 'collection/base'

module Typekit
  module Collection
    def self.build(*arguments)
      Base.new(*arguments)
    end
  end
end
