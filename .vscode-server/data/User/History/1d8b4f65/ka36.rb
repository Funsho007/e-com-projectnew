Rails.application.routes.draw do
  get 'customers/index'
  get 'customers/show'
  get 'customers/new'
  get 'customers/create'
  get 'customers/edit'
  get 'customers/update'
  get 'customers/destroy'
  get 'pages/contact'
  get 'pages/about'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  # config/routes.rb
  root to: 'products#index'
  get 'contact', to: 'pages#contact'
  get 'about', to: 'pages#about'

  resources :products, only: [:index, :show]
  resources :carts, only: [:show, :update, :destroy]
  resources :orders, only: [:create, :show]

 get '/products/filter_by_category', to: 'products#index', as: 'filter_by_category_products'
end
