module Typekit
  module Element
    module Association
      def possessions
        @possessions ||= []
      end

      def owners
        @owners ||= []
      end

      def has_many(name)
        possessions << name

        define_method(name) do
          raise Error, 'Not configured' unless attributes.key?(name)
          return attributes[name] if attributes[name].is_a?(Collection::Base)
          attributes[name] = Collection.build(name, self, attributes[name])
        end

        define_method("#{ name }=") do |collection|
          attributes[name] = collection
        end
      end

      def belongs_to(name)
        owners << name

        define_method(name) do
          raise Error, 'Not configured' unless attributes.key?(name)
          return attributes[name] if attributes[name].is_a?(Element::Base)
          attributes[name] = Element.build(name, self, attributes[name])
        end
      end
    end
  end
end
