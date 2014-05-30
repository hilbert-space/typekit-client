Dir[File.join(__dir__, 'dictionary', '*.rb')].each do |file|
  require_relative "dictionary/#{ File.basename(file, '.*rb') }"
end

module Typekit
  module Dictionary
    Error = Class.new(Typekit::Error)

    def self.lookup(name)
      self.const_get(name.to_s.capitalize).new
    rescue NameError
      raise Error, 'Unknown processor'
    end
  end
end
