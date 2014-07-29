module Typekit
  module Element
    module Persistence
      def new?
        id.to_s.empty?
      end

      def persistent?
        !(new? || deleted?)
      end

      def deleted?
        !!@deleted
      end

      def save!
        if new?
          element = process(:create, serialize)
        else
          element = process(:update, id, serialize)
        end
        become(element)
        @deleted = false
        true
      end

      def delete!
        process(:delete, id) if persistent?
        @deleted = true
        true
      end

      [:save, :delete].each do |method|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{method}
            #{method}!
          rescue ServerError
            false
          end
        CODE
      end
    end
  end
end
