# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  post '/cart', to: 'carts#add_product'

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
