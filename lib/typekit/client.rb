module Typekit
  module Client
    def self.new(**options)
      raise Error, 'Token is missing' unless options.key?(:token)

      client = Module.new
      client.extend(InstanceMethods)
      client.options = Typekit.defaults.merge(options)

      client
    end

    module InstanceMethods
      attr_accessor :options

      [ :process, :index, :show, :create, :update, :delete ].each do |method|
        define_method(method) do |*arguments|
          translate(engine.send(method, *arguments))
        end
      end

      private

      def engine
        @engine ||= build_engine
      end

      def build_engine
        engine_options = options.merge(dictionary: Typekit.dictionary,
          headers: Typekit.headers.call(options[:token]))

        version = options[:version]
        format = options[:format]

        Apitizer::Base.new(**engine_options) do
          instance_exec(version, format, &Typekit.schema)
        end
      end

      def translate(result)
        unless result.is_a?(Hash) && result.length == 1
          raise Error, 'Unknown server response'
        end
        name, object = *result.first
        converter(name).process(result, object)
      end

      def const_missing(name)
        resource(name)
      end

      def converter(name)
        (@converters ||= {})[name] ||= Converter.build(name, self)
      end

      def resource(name)
        (@resources ||= {})[name] ||= Record.build(name, self)
      end
    end

    module Proxy
      def proxy(owner = nil, token = nil)
        self.client = owner.respond_to?(:client) ? owner.client : owner
        self.token = token || Helper.tokenize(self.class)
      end

      private

      attr_accessor :client, :token

      def process(action, *arguments)
        client.process(action, token, *arguments)
      end
    end
  end
end
