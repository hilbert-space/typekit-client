require 'forwardable'

module Typekit
  class Client
    extend Forwardable

    def_delegators :@config, :map, :dispatcher, :processor
    private def_delegator :dispatcher, :deliver
    private def_delegator :processor, :process

    def initialize(spec: :default, **options)
      @config = Config.build(spec, **options)
    end

    def perform(action, path, parameters = {})
      process(deliver(trace(action, path, parameters)))
    end

    Typekit.actions.each do |action|
      define_method(action) do |path, parameters = {}|
        perform(action, path, parameters)
      end
    end

    private

    def prepare(action, path, parameters)
      [ action.to_sym, Array(path).map(&:to_sym), parameters ]
    end

    def trace(action, path, parameters)
      action, path, parameters = prepare(action, path, parameters)
      request = Connection::Request.new(action: action, parameters: parameters)
      map.trace(request, path)
    end
  end
end
