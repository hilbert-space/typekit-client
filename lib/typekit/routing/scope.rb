module Typekit
  module Routing
    class Scope < Node
      def initialize(path)
        @path = path
      end

      def match(name)
        !lookup(name).nil?
      end

      def process(request, path)
        @path.each { |chunk| request << chunk }
      end
    end
  end
end
