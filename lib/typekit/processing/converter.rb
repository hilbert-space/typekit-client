Dir[File.join(__dir__, 'converter', '*.rb')].each do |file|
  require_relative "converter/#{ File.basename(file, '.*rb') }"
end

module Typekit
  module Processing
    module Converter
      def self.build(name)
        self.const_get(name.to_s.capitalize).new
      rescue NameError
        raise Error, 'Unknown converter'
      end
    end
  end
end
