module Typekit
  class Collection
    extend Forwardable
    include Enumerable

    def_delegators :@records, :to_json, :each, :<=>

    def initialize(name, collection_attributes = nil)
      @klass = Record.classify(name)
      @records = collection_attributes.map do |attributes|
        @klass.new(attributes)
      end
    end
  end
end
