require_relative 'element/base'
require_relative 'element/kit'
require_relative 'element/family'

module Typekit
  module Element
    def self.classes
      # FIXME: cache?
      ObjectSpace.each_object(Class).select do |klass|
        klass < Typekit::Element::Base
      end
    end

    def self.collections
      classes.map(&:to_s).map(&:downcase).map do |name|
        Helper.pluralize(name.sub(/.*::/, '')).to_sym
      end
    end
  end
end
