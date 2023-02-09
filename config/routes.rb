# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'api/v1/ping#index'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'ping', to: 'ping#index'

      namespace :products do
        get '', to: 'list#index'
        patch ':code', to: 'update#index'
        post 'quote', to: 'quote#index'
      end
    end
  end
end
