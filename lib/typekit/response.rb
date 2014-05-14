module Typekit
  class Response
    attr_reader :code, :content

    def initialize options
      @code = options[:code]
      @content = options[:content]
    end

    def success?
      @code == 200
    end

    def failed?
      !success?
    end
  end
end
