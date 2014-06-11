module Typekit
  class Resource
    include Client::Proxy

    attr_reader :client, :token

    def initialize(client, name)
      @client = client
      @token = Helper.tokenize(name)
    end

    def all
      process(:index)
    end
  end
end
