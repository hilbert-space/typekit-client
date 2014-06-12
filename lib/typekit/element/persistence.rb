module Typekit
  module Element
    module Persistence
      def delete
        @deleted ||= process(:delete, id)
      end

      def deleted?
        @deleted
      end
    end
  end
end
