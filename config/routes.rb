require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users
  resources :companies
  resources :funding_rounds
  resources :investors
  resources :jobs

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq', as: :sidekiq
  end

  root 'companies#index'
end
