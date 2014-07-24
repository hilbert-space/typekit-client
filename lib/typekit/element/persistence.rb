module Typekit
  module Element
    module Persistence
      def new?
        defined?(@new) ? @new : true
      end

      def persistent?
        !(new? || deleted?)
      end

      def persistent!
        @new = false
        @deleted = false
      end

      def save
        if new?
          become(process(:create, serialize))
        else
          become(process(:update, id, serialize))
        end
        persistent!
        true
      end

      def delete
        @deleted ||= persistent? ? process(:delete, id) : true
      end

      def deleted?
        !!@deleted
      end
    end
  end
end
