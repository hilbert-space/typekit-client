module Typekit
  module Record
    class Kit < Base
      has_attributes :id, :link, :name, :analytics, :badge, :domains,
        :published

      has_attributes :families
    end
  end
end
