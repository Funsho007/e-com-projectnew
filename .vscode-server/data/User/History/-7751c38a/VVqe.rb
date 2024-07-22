Rails.application.routes.draw do
  # Devise routes for admin users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Define RESTful routes for each resource
  resources :people, only: [:index, :show, :new, :create]
  resources :planets, only: [:index, :show]
  resources :spacecrafts, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
  resources :films, only: [:index, :show]
  resources :species, only: [:index, :show]

  # Root path to people#index
  root 'people#index'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
