require_relative 'converter/element'
require_relative 'converter/collection'
require_relative 'converter/boolean'
require_relative 'converter/datetime'
require_relative 'converter/errors'
require_relative 'converter/unknown'

module Typekit
  module Converter
    MAPPING = {
      :element => Element,
      :collection => Collection,

      'ok' => Boolean,
      'errors' => Errors,
      'published' => DateTime,

      nil => Errors
    }
    MAPPING.default = Unknown

    def self.build(name, client = nil)
      MAPPING[Resource.identify(name) || name].new(name, client)
    end
  end
end