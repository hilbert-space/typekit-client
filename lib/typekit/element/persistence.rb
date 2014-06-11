module Typekit
  module Element
    module Persistence
      def delete
        process(:delete, id)
      end
    end
  end
end
