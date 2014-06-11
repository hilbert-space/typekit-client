require_relative 'resource/kit'
require_relative 'resource/family'
require_relative 'resource/library'
require_relative 'resource/variation'

module Typekit
  module Resource
    def self.identify(name)
      if Element.dictionary.key?(name.to_s.to_sym)
        :collection
      elsif Element.dictionary.key?(Helper.pluralize(name.to_s).to_sym)
        :element
      end
    end
  end
end
