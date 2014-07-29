module Typekit
  @defaults = { version: 1, format: :json }

  @schema = Proc.new do |version, format|
    address "https://typekit.com/api/v#{version}/#{format}"

    resources :kits do
      resources :families, only: [:show, :update, :delete]
      show :published, on: :member
      update :publish, on: :member
    end

    resources :families, only: :show do
      show ':variation', on: :member
    end

    resources :libraries, only: [:index, :show]
  end

  @dictionary = { :update => :post } # not PATCH

  @headers = Proc.new do |token|
    { 'X-Typekit-Token' => token }
  end

  singleton_class.class_eval do
    attr_reader :defaults, :schema, :dictionary, :headers
  end
end
