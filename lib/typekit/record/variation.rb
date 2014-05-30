module Typekit
  module Record
    class Variation < Base
      has_attributes :id, :name, :font_style, :font_variant, :font_weight,
        :foundry, :postscript_name

      has_attributes :family, :libraries
    end
  end
end
