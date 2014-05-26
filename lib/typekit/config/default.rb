module Typekit
  module Config
    class Default < Base
      def map
        @map ||= draw
      end

      def connection
        @connection ||= Connection.new(token: token)
      end

      def processor
        @processor ||= Processor.new(format: format)
      end

      private

      def draw
        context = [ Config.address, "v#{ version }", format ]
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
    end
  end
end
