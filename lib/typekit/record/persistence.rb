module Typekit
  module Record
    module Persistence
      def delete
        process(:delete, id)
      end
    end
  end
end
