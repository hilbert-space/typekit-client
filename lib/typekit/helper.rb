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

    def self.symbolize_keys(hash)
      Hash[hash.map { |k, v| [ k.to_sym, v ] }]
    end
  end
end
