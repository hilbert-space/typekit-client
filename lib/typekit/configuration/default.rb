module Typekit
  module Configuration
    class Default < Base
      private

      def build_map
        context = [ Typekit.address, "v#{ version }", format ]
        Routing::Map.new do
          scope context do
            resources :families, only: :show do
              show ':variant', on: :member
            end

            resources :kits do
              resources :families
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
    end
  end
end
