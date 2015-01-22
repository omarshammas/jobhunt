require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users
  resources :companies
  resources :funding_rounds
  resources :investors
  resources :jobs

  scope 'analysis', as: :analysis  do
    get 'scatter_plot', to: 'analysis#scatter_plot'
    get 'line_chart_time_alive', to: 'analysis#line_chart_time_alive'
    get 'line_chart_since_2005', to: 'analysis#line_chart_since_2005'
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq', as: :sidekiq
  end

  root 'companies#index'
end
