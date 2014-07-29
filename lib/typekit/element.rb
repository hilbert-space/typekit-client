require_relative 'element/association'
require_relative 'element/persistence'
require_relative 'element/query'
require_relative 'element/serialization'
require_relative 'element/base'

module Typekit
  module Element
    def self.dictionary
      @dictionary ||= Hash[
        ObjectSpace.each_object(Class).select do |klass|
          klass < Base && klass.name
        end.map do |klass|
          [Helper.tokenize(klass), klass]
        end
      ]
    end

    def self.classify(name)
      dictionary[Helper.tokenize(name)]
    end

    def self.build(name, *arguments)
      classify(name).new(*arguments)
    end
  end
end
