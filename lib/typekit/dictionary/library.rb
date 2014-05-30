module Typekit
  module Dictionary
    class Library
      def process(response, attributes)
        Record::Library.new(attributes)
      end
    end
  end
end
