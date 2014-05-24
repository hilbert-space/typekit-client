require 'rack/utils'

module Typekit
  module Helper
    def self.pluralize(string)
      # TODO: generalize?
      case string
      when /s$/
        string
      when /y$/
        string.sub(/y$/, 'ies')
      else
        "#{ string }s"
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
