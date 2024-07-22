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
  get 'films/index'
  get 'films/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get 'about', to: 'pages#about'

  Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/about'
    resources :films, only: [:index, :show]
    resources :people, only: [:index, :show]
    resources :planets, only: [:index, :show]
    resources :vehicles, only: [:index, :show]
    resources :starships, only: [:index, :show]
    resources :species, only: [:index, :show]

    get 'about', to: 'pages#about'

    root 'pages#home'
  end


end
