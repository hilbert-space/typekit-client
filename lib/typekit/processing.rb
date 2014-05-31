require_relative 'processing/parser'
require_relative 'processing/converter'
require_relative 'processing/translator'

module Typekit
  module Processing
    Error = Class.new(Typekit::Error)
  end
end
