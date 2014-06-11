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
          translator.process(engine.send(method, *arguments))
        end
      end

      private

      def engine
        @engine ||= build_engine
      end

      def translator
        @translator ||= Processing::Translator.new
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

      def const_missing(name)
        Collection.build(name, client: self)
      end
    end

    module Proxy
      def process(action, *arguments)
        client.process(action, token, *arguments)
      end

      def client
        raise Error, 'Client is not given'
      end

      def token
        @token ||= Helper.tokenize(self.class)
      end
    end
  end
end
