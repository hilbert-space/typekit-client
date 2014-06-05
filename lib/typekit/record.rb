require_relative 'record/base'
require_relative 'record/family'
require_relative 'record/variation'
require_relative 'record/kit'
require_relative 'record/library'

module Typekit
  module Record
    def self.classes
      @classes ||= Hash[
        ObjectSpace.each_object(Class).select { |k| k < Base && k.name }.
          map { |k| [ k.name.downcase.sub(/^.*::/, '').to_sym, k ] }
      ]
    end

    def self.classify(name)
      classes[Helper.singularize(name.to_s).to_sym]
    end

    def self.collections
      @collections ||= classes.keys.map(&:to_s).
        map(&Helper.method(:pluralize)).map(&:to_sym)
    end

    def self.members
      @members ||= classes.keys
    end

    def self.collection?(name)
      collections.include?(name.to_sym)
    end

    def self.member?(name)
      members.include?(name.to_sym)
    end
  end
end
