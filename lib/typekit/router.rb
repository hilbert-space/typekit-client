module Typekit
  class Router
    URI_BASE = 'https://typekit.com/api'

    def initialize options
      @version = options[:version]
      @format = options[:format]
    end

    def locate resource
      [ URI_BASE, "v#{ @version }", @format, *Array(resource) ].join('/')
    end
  end
end
