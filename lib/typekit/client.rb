module Typekit
  module Client
    def self.new(**options)
      raise Error, 'Token is missing' unless options.key?(:token)

      client = Module.new
      client.extend(InstanceMethods)
      client.configure(Typekit.defaults.merge(options))

      client
    end

    module InstanceMethods
      [ :process, :index, :show, :create, :update, :delete ].each do |method|
        define_method(method) do |*arguments|
          translate(engine.send(method, *arguments))
        end
      end

      def configure(options)
        self.options = options
      end

      private

      attr_accessor :options

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
        record_class(name)
      end

      def converter(name)
        (@converters ||= {})[name] ||= Converter.build(name, self)
      end

      def record_class(name)
        (@record_classes ||= {})[name] ||= Record.build(name, self)
      end
    end

    module Proxy
      attr_reader :client, :token

      def connect(object = nil, token = Helper.tokenize(self.class))
        self.client = object.respond_to?(:client) ? object.client : object
        self.token = token
      end

      private

      attr_writer :client, :token

      def process(action, *arguments)
        raise Error, 'Client is not specified' if client.nil?
        client.process(action, token, *arguments)
      end
    end
  end
end
