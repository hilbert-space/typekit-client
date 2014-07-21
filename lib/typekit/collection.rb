require_relative 'collection/persistence'
require_relative 'collection/serialization'
require_relative 'collection/base'

module Typekit
  module Collection
    def self.build(name, *arguments)
      collection = Base.new(name, *arguments)
      collection.persistent!
      collection
    end
  end
end
