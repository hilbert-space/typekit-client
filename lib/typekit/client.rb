module Typekit
  class Client
    def initialize(version: 1, format: :json, token:)
      @router = Router.new(version: version, format: format)
      @connection = Connection.new(token: token)
      @processor = Processor.new(format: format)
    end

    Connection::METHODS.each do |method|
      define_method(method) do |resource, parameters = {}|
        uri = @router.locate(resource)
        response = @connection.send(method, uri, parameters)
        @processor.process(response)
      end
    end
  end
end
