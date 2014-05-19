module Typekit
  class Router
    URI_BASE = 'https://typekit.com/api'

    def initialize(version:, format:)
      @version = version
      @format = format
    end

    def locate(resource)
      [ URI_BASE, "v#{ @version }", @format, *Array(resource) ].join('/')
    end
  end
end
