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
        become(process(*(new? ? [ :create ] : [ :update, id ])))
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
