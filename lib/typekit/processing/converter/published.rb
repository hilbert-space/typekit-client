module Typekit
  module Processing
    module Converter
      class Published
        def process(response, date)
          Time.parse(date)
        end
      end
    end
  end
end
