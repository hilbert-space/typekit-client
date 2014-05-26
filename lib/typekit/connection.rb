require_relative 'connection/adaptor'
require_relative 'connection/request'
require_relative 'connection/response'
require_relative 'connection/dispatcher'

module Typekit
  module Connection
    Error = Class.new(Typekit::Error)
  end
end
