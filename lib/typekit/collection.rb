module Typekit
  class Collection
    extend Forwardable

    def_delegators :@records, :each, :map, :[]

    def initialize(name, attribute_collection)
      klass = Record.classify(name)
      @records = attribute_collection.map do |attributes|
        klass.new(attributes)
      end
    end
  end
end
