require_relative 'converter/record'
require_relative 'converter/collection'
require_relative 'converter/boolean'
require_relative 'converter/datetime'
require_relative 'converter/errors'
require_relative 'converter/unknown'

module Typekit
  module Processing
    module Converter
      MAPPING = {
        :record => Record,
        :collection => Collection,

        'ok' => Boolean,
        'errors' => Errors,
        'published' => DateTime,

        nil => Errors
      }
      MAPPING.default = Unknown

      def self.build(name)
        MAPPING[Typekit::Record.identify(name) || name].new(name)
      end
    end
  end
end
