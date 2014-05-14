module Typekit
  class Client
    def initialize options = {}
      options = { version: 1, format: :json }.merge(options)
      @router = Router.new options
      @connection = Connection.new options
      @processor = Processor.new options
    end

    Connection::METHODS.each do |method|
      define_method(method) do |resource, parameters = {}|
        uri = @router.locate resource
        response = @connection.send method, uri, parameters
        @processor.process response
      end
    end
  end
end
