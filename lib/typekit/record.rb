require_relative 'record/association'

require_relative 'record/base'
require_relative 'record/family'
require_relative 'record/variation'
require_relative 'record/kit'
require_relative 'record/library'

module Typekit
  module Record
    def self.dictionary
      @dictionary ||= Hash[
        ObjectSpace.each_object(Class).select do |klass|
          klass < Base && klass.name
        end.map do |klass|
          [ Helper.tokenize(klass), klass ]
        end
      ]
    end

    def self.classify(name)
      dictionary[Helper.pluralize(name.to_s).to_sym]
    end

    def self.identify(name)
      if dictionary.key?(name.to_s.to_sym)
        :collection
      elsif dictionary.key?(Helper.pluralize(name.to_s).to_sym)
        :record
      end
    end

    def self.build(name, *arguments)
      classify(name).new(*arguments)
    end
  end
end
