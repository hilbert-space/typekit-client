module Typekit
  module Element
    module Persistence
      def new?
        defined?(@new) ? @new: true
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
          become(process(:create, to_h))
        else
          become(process(:update, id, to_h))
        end
        persistent!
        true
      end

      def delete
        @deleted ||= process(:delete, id)
      end

      def deleted?
        !!@deleted
      end
    end
  end
end
