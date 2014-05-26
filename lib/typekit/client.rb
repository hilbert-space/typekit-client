require 'forwardable'

module Typekit
  class Client
    extend Forwardable

    def_delegators :@config, :map, :dispatcher, :processor

    def initialize(spec: :default, **options)
      @config = Config.build(spec, **options)
    end

    Typekit.actions.each do |action|
      define_method(action) do |path, parameters = {}|
        options = { action: action, parameters: parameters }
        request = map.trace(Connection::Request.new(options), path)
        response = dispatcher.deliver(request)
        processor.process(response)
      end
    end
  end
end
