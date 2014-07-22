module Typekit
  module Helper
    def self.pluralize(name)
      case name
      when /^.*s$/
        name
      when /^(?<root>.*)y$/
        "#{ Regexp.last_match(:root) }ies"
      else
        "#{ name }s"
      end
    end

    def self.singularize(name)
      case name
      when /^(?<root>.*)ies$/
        "#{ Regexp.last_match(:root) }y"
      when /^(?<root>.*)s$/
        Regexp.last_match(:root)
      else
        name
      end
    end

    def self.constantize(name)
      name.to_s.capitalize.to_sym
    end

    def self.tokenize(name, pluralize: true)
      name = name.to_s.sub(/^.*::/, '').downcase
      (pluralize ? pluralize(name) : name).to_sym
    end

    def self.symbolize_keys(hash)
      Hash[hash.map { |k, v| [ k.to_sym, v ] }]
    end

    def self.extract_hash!(arguments)
      arguments.last.is_a?(Hash) ? arguments.pop : {}
    end

    def self.extract_array!(arguments)
      arguments.last.is_a?(Array) ? arguments.pop : {}
    end
  end
end
