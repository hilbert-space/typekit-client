module Typekit
  module Connection
    class Dispatcher
      def initialize(adaptor: :standard, token:)
        @token = token
        @adaptor = Adaptor.build(adaptor)
      end

      def process(request)
        method = Helper.translate_action(request.action)
        code, _, body = @adaptor.process(method, request.address,
          request.parameters, 'X-Typekit-Token' => @token)
        Response.new(code: code.to_i, content: body)
      end
    end
  end
end
