require_relative 'resource/kit'
require_relative 'resource/family'
require_relative 'resource/library'
require_relative 'resource/variation'

module Typekit
  module Resource
    def self.identify(name)
      if Element.dictionary.key?(Helper.tokenize(name, pluralize: false))
        :collection
      elsif Element.dictionary.key?(Helper.tokenize(name))
        :element
      end
    end

    def self.build(name, client)
      klass = Element.classify(name)
      Class.new(klass) do
        proxy(client, Helper.tokenize(name))

        singleton_class.instance_eval do
          define_method(:new) do |*arguments|
            klass.new(client, *arguments)
          end
        end
      end
    end
  end
end
