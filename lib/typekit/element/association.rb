module Typekit
  module Element
    module Association
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def possessions
          @possessions ||= []
        end

        def owners
          @owners ||= []
        end

        def has_many(name)
          possessions << name

          define_method(name) do
            value = attributes[name]
            return value if value.is_a?(Collection::Base)

            unless value.nil?
              attributes[name] = Collection.build(name, self, value)
              return attributes[name]
            end

            if feature?(:persistence) && new?
              attributes[name] = Collection.build(name, self, [])
              return attributes[name]
            end

            load!

            value = attributes[name]
            raise Error, 'Cannot load the association' if value.nil?

            attributes[name] = Collection.build(name, self, value)
          end

          define_method("#{ name }=") do |value|
            if value.is_a?(Collection::Base)
              attributes[name] = value
            else
              attributes[name] = Collection.build(name, self, value)
            end
          end
        end

        def belongs_to(name)
          owners << name

          define_method(name) do
            value = attributes[name]
            return value if value.nil? || value.is_a?(Element::Base)
            attributes[name] = Element.build(name, self, attributes[name])
          end
        end
      end
    end
  end
end
