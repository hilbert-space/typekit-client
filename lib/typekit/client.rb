module Typekit
  class Client
    extend Forwardable

    def_delegator :translator, :process, :translate

    def initialize(**options)
      @options = Typekit.defaults.merge(options)
      raise Error, 'Token is missing' unless @options.key?(:token)
    end

    [ :process, :index, :show, :create, :update, :delete ].each do |method|
      define_method(method) do |*arguments|
        translate(engine.send(method, *arguments))
      end
    end
    alias_method :perform, :process

    private

    [ :engine, :translator ].each do |component|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{ component }
          @#{ component } ||= build_#{ component }
        end
      METHOD
    end

    def build_engine
      version = @options[:version]
      format = @options[:format]

      options = @options.merge(dictionary: Typekit.dictionary,
        headers: Typekit.headers.call(@options[:token]))

      Apitizer::Base.new(**options) do
        instance_exec(version, format, &Typekit.schema)
      end
    end

    def build_translator
      Processing::Translator.new
    end
  end
end
