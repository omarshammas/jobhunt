require 'sidekiq/web'

Rails.application.routes.draw do
  resources :companies
  resources :funding_rounds
  resources :investors

  mount Sidekiq::Web => '/sidekiq'

  root 'companies#index'
end
