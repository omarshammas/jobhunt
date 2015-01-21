require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users
  resources :companies
  resources :funding_rounds
  resources :investors
  resources :jobs

  mount Sidekiq::Web => '/sidekiq'

  root 'companies#index'
end
