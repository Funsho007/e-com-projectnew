Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/about'
  get 'species/index'
  get 'species/show'
  get 'starships/index'
  get 'starships/show'
  get 'vehicles/index'
  get 'vehicles/show'
  get 'planets/index'
  get 'planets/show'
  get 'people/index'
  get 'people/show'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Routes for static pages
  get 'about', to: 'pages#about'
  root 'pages#home'

  # Nested resources for main data entities
  resources :films, only: [:index, :show] do
    collection do
      get :autocomplete
    end
  end

  resources :people, only: [:index, :show]
  resources :planets, only: [:index, :show]
  resources :vehicles, only: [:index, :show]
  resources :starships, only: [:index, :show]
  resources :species, only: [:index, :show]
  resources :films, only: [:index, :show]
end
