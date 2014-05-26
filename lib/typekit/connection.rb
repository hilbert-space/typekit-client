require_relative 'connection/adaptor'
require_relative 'connection/request'
require_relative 'connection/response'

module Typekit
  module Connection
    Error = Class.new(Typekit::Error)
  end
end
