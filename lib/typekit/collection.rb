require_relative 'collection/base'

module Typekit
  module Collection
    def self.build(name, *arguments)
      Base.new(name, *arguments)
    end
  end
end
