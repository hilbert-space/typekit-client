module Typekit
  module Record
    class Kit < Base
      has_attributes :id, :name, :analytics, :badge, :domains
      has_many :families
    end
  end
end
