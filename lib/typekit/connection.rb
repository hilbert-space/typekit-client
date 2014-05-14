require 'net/https'
require 'uri'
require 'rack/utils'

module Typekit
  class Connection
    METHODS = [ :get, :post, :delete ]

    def initialize options
      @token = options[:token] || ''
      raise ArgumentError, 'The API token is required.' if @token.empty?
    end

    METHODS.each do |method|
      define_method(method) do |uri, parameters = {}|
        request method, uri, parameters
      end
    end

    protected

    def request method, uri, parameters = {}
      unless parameters.empty?
        uri = "#{ uri }?#{ Rack::Utils.build_nested_query parameters }"
      end

      klass = Net::HTTP.const_get method.to_s.capitalize
      http_request = klass.new URI(uri)
      http_request['X-Typekit-Token'] = @token

      http = Net::HTTP.new http_request.uri.host, http_request.uri.port
      http.use_ssl = true

      response = http.request http_request
      Response.new code: response.code.to_i, content: response.body
    rescue SocketError
      raise SocketError, 'Unable to connect to Typekit’s API.'
    end
  end
end
