Rails.application.routes.draw do
  devise_for :customers
  get 'static_pages/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get "up" => "rails/health#show", as: :rails_health_check
  get 'static_pages/:title', to: 'static_pages#show', as: 'static_page'

  resources :products, only: [:index, :show] do
    collection do
      get 'filter', to: 'products#filter'
       get 'filter_by_category'
      get "search"
    end
  end

  resources :categories, only: [:show]
end
R?
  resources :customers, only: [:show]
  devise_for :customers

  get 'home/index'

  get 'page/:permalink', to: 'pages#show', as: 'permalink_page'
  resources :pages, only: [:edit, :update], param: :permalink
  get '/contact', to: 'pages#show', defaults: { permalink: 'contact' }, as: 'contact_page'
  get '/about', to: 'pages#show', defaults: { permalink: 'about' }, as: 'about_page'
  post '/contact', to: 'contacts#create', as: 'contact_submit'

  post 'contact', to: 'pages#contact', as: 'contact'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :orders, only: [:index, :show]

  resources :types do
    # resources :products, only: :index
  end

  resources :brands do
    # resources :products, only: :index
  end

  resources :categories do
    # resources :products, only:[ :index, :show]
  end

  resources :tags do
    # resources :products, only: [:index, :show]
  end

  resources :products do
    collection do
      get 'filter'
      get 'filter_by_category'
      get 'search'
    end

    member do
      post 'add_to_cart'
    end
  end

  get 'cart', to: 'carts#show'
  put 'cart/update', to: 'carts#update'
  delete 'cart/remove', to: 'carts#remove'

  namespace :admin do
    resources :pages, only: [:edit, :update]
  end

  get 'pages/contact', to: 'pages#show', defaults: { permalink: 'contact' }
  get 'pages/about', to: 'pages#show', defaults: { permalink: 'about' }
  get '/about', to: 'pages#about'
  get ':permalink', to: 'pages#show', as: :dynamic_page

  root 'home#index'
end
