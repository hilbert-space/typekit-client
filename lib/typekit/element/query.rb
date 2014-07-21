module Typekit
  module Element
    module Query
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def all
          process(:index)
        end

        def find(id)
          process(:show, id)
        end
      end
    end
  end
end
