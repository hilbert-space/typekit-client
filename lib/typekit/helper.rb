require 'rack/utils'

module Typekit
  module Helper
    Error = Class.new(Typekit::Error)

    def self.member_action?(action)
      case action
      when :show, :update, :delete
        true
      when :index, :create
        false
      else
        raise Error, 'Unknown action'
      end
    end

    def self.translate_action(action)
      case action
      when :index, :show
        :get
      when :create, :update
        :post
      when :delete
        :delete
      else
        raise Error, 'Unknown action'
      end
    end

    def self.build_query(parameters)
      Rack::Utils.build_nested_query(prepare_parameters(parameters))
    end

    private

    def self.prepare_parameters(parameters)
      # PATCH: https://github.com/rack/rack/issues/557
      Hash[
        parameters.map do |key, value|
          case value
          when Integer, TrueClass, FalseClass
            [ key, value.to_s ]
          when Hash
            [ key, prepare_parameters(value) ]
          else
            [ key, value ]
          end
        end
      ]
    end
  end
end
