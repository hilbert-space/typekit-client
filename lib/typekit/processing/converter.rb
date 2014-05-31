require_relative 'converter/record'
require_relative 'converter/records'
require_relative 'converter/boolean'
require_relative 'converter/datetime'
require_relative 'converter/errors'
require_relative 'converter/unknown'

module Typekit
  module Processing
    module Converter
      MAPPING = {
        'ok' => Boolean,
        'errors' => Errors,
        'published' => DateTime
      }.freeze

      def self.build(name)
        if MAPPING.key?(name)
          MAPPING[name].new
        elsif Typekit::Record.collection?(name)
          Records.new(name)
        elsif Typekit::Record.member?(name)
          Record.new(name)
        else
          Unknown.new(name)
        end
      rescue NameError
        raise Error, 'Unknown converter'
      end
    end
  end
end
