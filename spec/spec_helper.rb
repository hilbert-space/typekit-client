require 'webmock/rspec'
require 'vcr'
require 'typekit'

require_relative 'support/resource_helper'

RSpec.configure do |config|
  config.disable_monkey_patching!
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    allow_unused_http_interactions: false
  }
  config.allow_http_connections_when_no_cassette = false
end
