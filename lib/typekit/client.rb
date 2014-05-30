require 'forwardable'

module Typekit
  class Client
    extend Forwardable

    def_delegators :@config, :map, :dispatcher, :translator
    private def_delegator :dispatcher, :process, :dispatch
    private def_delegator :translator, :process, :translate

    def initialize(config: :default, **options)
      @config = Configuration.build(config, **options)
    end

    def perform(*arguments)
      translate(dispatch(trace(*arguments)))
    end

    Typekit.actions.each do |action|
      define_method(action) do |*arguments|
        perform(action, *arguments)
      end
    end

    private

    def prepare(action, *path)
      parameters = path.last.is_a?(Hash) ? path.pop : {}
      [ action.to_sym, path.flatten.map(&:to_sym), parameters ]
    end

    def trace(*arguments)
      action, path, parameters = prepare(*arguments)
      request = Connection::Request.new(action: action, parameters: parameters)
      map.trace(request, path)
    end
  end
end
