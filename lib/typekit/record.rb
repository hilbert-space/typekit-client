require_relative 'record/base'
require_relative 'record/family'
require_relative 'record/variation'
require_relative 'record/kit'
require_relative 'record/library'

module Typekit
  module Record
    def self.classes
      @classes ||= ObjectSpace.each_object(Class).select do |klass|
        klass < Base
      end
    end

    def self.collections
      @collections ||= members.map(&:to_s).map do |name|
        Helper.pluralize(name.to_s)
      end.map(&:to_sym)
    end

    def self.members
      @members ||= classes.map(&:to_s).map(&:downcase).map do |name|
        name.sub(/^.*::/, '')
      end.map(&:to_sym)
    end

    def self.collection?(name)
      collections.include?(name.to_s.to_sym)
    end

    def self.member?(name)
      members.include?(name.to_s.to_sym)
    end
  end
end
