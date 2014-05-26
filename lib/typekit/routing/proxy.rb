module Typekit
  module Routing
    class Proxy
      def initialize(owner, **options)
        @owner = owner
        @options = options
      end

      def method_missing(name, *arguments, **options, &block)
        name = :"define_#{ name }"
        return super unless @owner.respond_to?(name)
        # NOTE: https://bugs.ruby-lang.org/issues/9776
        @owner.send(name, *arguments, **options, **@options, &block)
      end
    end
  end
end
