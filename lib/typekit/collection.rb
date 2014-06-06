module Typekit
  class Collection
    extend Forwardable

    def_delegator :@records, :to_json
    def_delegators :@records, :each, :map, :[], :size, :length

    def initialize(name, collection_attributes = nil)
      @klass = Record.classify(name)
      @records = collection_attributes.map do |attributes|
        @klass.new(attributes)
      end
    end
  end
end
