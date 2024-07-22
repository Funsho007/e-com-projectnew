Rails.application.routes.draw do
  get 'species/index'
  get 'species/show'
  get 'films/index'
  get 'films/show'
  get 'vehicles/index'
  get 'vehicles/show'
  get 'spacecrafts/index'
  get 'spacecrafts/show'
  get 'planets/index'
  get 'planets/show'
  get 'people/index'
  get 'people/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  Rails.application.routes.draw do
    resources :people, only: [:index, :show]
    resources :planets, only: [:index, :show]
    resources :spacecrafts, only: [:index, :show]
    resources :vehicles, only: [:index, :show]
    resources :films, only: [:index, :show]
    resources :species, only: [:index, :show]

    root 'people#index'
end
