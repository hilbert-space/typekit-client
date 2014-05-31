require_relative 'routing/node'
require_relative 'routing/proxy'
require_relative 'routing/mapper'

module Typekit
  module Routing
    Error = Class.new(Typekit::Error)
  end
end
