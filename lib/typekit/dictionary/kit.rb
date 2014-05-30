module Typekit
  module Dictionary
    class Kit
      def process(response, attributes)
        Record::Kit.new(attributes)
      end
    end
  end
end
