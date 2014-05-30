module Typekit
  module Record
    class Family < Base
      has_attributes :id, :link, :name, :description, :foundry,
        :css_names, :css_stack, :browser_info, :web_link, :slug, :subset

      has_attributes :libraries, :variations
    end
  end
end
