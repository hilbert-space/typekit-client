module Typekit
  module Connection
    class Dispatcher
      def initialize(adaptor: :standard, token:)
        @token = token
        @adaptor = Adaptor.const_get(adaptor.to_s.capitalize).new
      rescue NameError
        raise Error, 'Unknown connection adaptor'
      end

      def deliver(request)
        method = Helper.translate_action(request.action)
        address = request.address
        parameters = request.parameters
        headers = { 'X-Typekit-Token' => @token }
        Response.new(@adaptor.process(method, address, parameters, headers))
      end
    end
  end
end
