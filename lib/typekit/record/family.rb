module Typekit
  module Record
    class Family < Base
      has_attributes :id, :name, :description, :foundry,
        :css_stack, :browser_info, :web_link, :slug
    end
  end
end
