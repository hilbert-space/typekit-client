module Typekit
  module Element
    module Query
      def all
        process(:index)
      end

      def find(id)
        process(:show, id)
      end
    end
  end
end
