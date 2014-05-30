module Typekit
  module Dictionary
    class Family
      def process(response, attributes)
        Record::Family.new(attributes)
      end
    end
  end
end
