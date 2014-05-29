module Typekit
  module Configuration
    class Default < Base
      private

      def build_map
        context = build_context
        Routing::Map.new do
          scope context do
            resources :families, only: :show do
              show ':variant', on: :member
            end

            resources :kits do
              resources :families, only: [ :show, :update, :delete ]
              show :published, on: :member
              update :publish, on: :member
            end

            resources :libraries, only: [ :index, :show ]
          end
        end
      end

      def build_dispatcher
        Connection::Dispatcher.new(adaptor: :standard, token: token)
      end

      def build_processor
        Processor.new(format: format)
      end

      def build_context
        [ Typekit.address, "v#{ version }", format ]
      end
    end
  end
end
