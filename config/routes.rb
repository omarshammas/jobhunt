Rails.application.routes.draw do
  resources :companies
  resources :funding_rounds
  resources :investors
  root 'companies#index'
end
