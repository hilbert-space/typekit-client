module Typekit
  Error = Class.new(StandardError)

  @defaults = { version: 1, format: :json }.freeze

  @schema = Proc.new do |version, format|
    address "https://typekit.com/api/v#{ version }/#{ format }"

    resources :families, only: :show do
      show ':variant', on: :member
    end

    resources :kits do
      resources :families, only: [ :show, :update, :delete ]
      show :published, on: :member
      update :publish, on: :member
    end

    resources :libraries, only: [ :index, :show ]
  end

  @headers = Proc.new do |token|
    { 'X-Typekit-Token' => token }
  end

  singleton_class.class_eval do
    attr_reader :defaults, :schema, :headers
  end
end
