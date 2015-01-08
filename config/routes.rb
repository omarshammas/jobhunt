Rails.application.routes.draw do
  resources :companies
  resources :funding_rounds
  root 'companies#index'
end
