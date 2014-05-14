require 'net/https'
require 'uri'

module Typekit
  class Connection
    METHODS = [ :get, :post, :delete ]

    def initialize options
      @token = options[:token]
    end

    METHODS.each do |method|
      define_method(method) do |uri, parameters = {}|
        request method, uri, parameters
      end
    end

    protected

    def request method, uri, parameters = {}
      case method
      when :get
        unless parameters.empty?
          uri = [ uri, URI.encode_www_form(parameters) ].join('?')
        end
        http_request = Net::HTTP::Get.new URI(uri)
      else
        klass = Net::HTTP.const_get method.to_s.capitalize
        http_request = klass.new URI(uri)
        http_request.set_form_data parameters unless parameters.empty?
      end

      http_request['X-Typekit-Token'] = @token

      http = Net::HTTP.new http_request.uri.host, http_request.uri.port
      http.use_ssl = true

      response = http.request http_request
      Response.new code: response.code.to_i, content: response.body
    end
  end
end
