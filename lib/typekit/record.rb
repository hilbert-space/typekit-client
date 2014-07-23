require_relative 'record/kit'
require_relative 'record/family'
require_relative 'record/library'
require_relative 'record/variation'

module Typekit
  module Record
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
        extend Client::Proxy

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
