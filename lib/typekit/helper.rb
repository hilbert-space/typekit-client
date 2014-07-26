module Typekit
  module Helper
    # Returns the plural form of the given word.
    #
    # @param word [String]
    # @return [String]
    def self.pluralize(word)
      case word
      when /^.*s$/
        word
      when /^(?<root>.*)y$/
        "#{ Regexp.last_match(:root) }ies"
      else
        "#{ word }s"
      end
    end

    # Returns the singular form of the given word.
    #
    # @param word [String]
    # @return [String]
    def self.singularize(word)
      case word
      when /^(?<root>.*)ies$/
        "#{ Regexp.last_match(:root) }y"
      when /^(?<root>.*)s$/
        Regexp.last_match(:root)
      else
        word
      end
    end

    # Constructs a symbol suitable for looking up modules among the constants
    # defined in a module.
    #
    # @param object [String, Symbol]
    # @return [Symbol]
    def self.constantize(object)
      object.to_s.sub(/^.*::/, '').capitalize.to_sym
    end

    # Constructs a symbolic representation of the given object.
    #
    # @param object
    # @option options [Boolean] :pluralize (true) indicates if the result
    #   should be plural
    def self.tokenize(object, options = {})
      name = object.to_s.sub(/^.*::/, '').downcase
      (options.fetch(:pluralize, true) ? pluralize(name) : name).to_sym
    end

    # Copies the given hash while converting its keys into symbols.
    #
    # @param hash [Hash]
    # @return [Hash]
    def self.symbolize_keys(hash)
      Hash[hash.map { |k, v| [ k.to_sym, v ] }]
    end

    # Removes and returns the last element of the given array if that element
    # is a hash; otherwise, a new hash is returned.
    #
    # @param array [Array]
    # @return [Hash]
    def self.extract_hash!(array)
      array.last.is_a?(Hash) ? array.pop : {}
    end

    # Removes and returns the last element of the given array if that element
    # is an array; otherwise, a new array is returned.
    #
    # @param array [Array]
    # @return [Array]
    def self.extract_array!(array)
      array.last.is_a?(Array) ? array.pop : {}
    end
  end
end
