Rails.application.routes.draw do
  # Checkout routes
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'index', to: 'checkout#index', as: 'checkout_index'
    get 'guest', to: 'checkout#guest', as: 'checkout_guest'
    post 'save_guest_address', to: 'checkout#save_guest_address', as: 'save_guest_address'
  end

  # Customer routes
  resources :customers, only: [:show]
  devise_for :customers

  # Home route
  get 'home/index'

  # Page routes
  get 'page/:permalink', to: 'pages#show', as: 'page'
  resources :pages, only: [:edit, :update]
  get '/contact', to: 'pages#show', defaults: { permalink: 'contact' }
  get '/about', to: 'pages#show', defaults: { permalink: 'about' }

  # Contact route
  post 'contact', to: 'contacts#create', as: 'contact'

  # Admin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Order routes
  resources :orders, only: [:index, :show]

  # Type, Brand, Category, Tag routes
  resources :types do
    resources :products, only: :index
  end

  resources :brands do
    resources :products, only: :index
  end

  resources :categories do
    resources :products, only: :index
  end

  resources :tags do
    resources :products, only: [:index, :show]
  end

  # Product routes
  resources :products, only: [:index, :show] do
    collection do
      get 'filter'
      get 'filter_by_category'
      get 'search'
    end

    member do
      post 'add_to_cart'
    end
  end

  # Cart routes
  get 'cart', to: 'carts#show'
  put 'cart/update', to: 'carts#update'
  delete 'cart/remove', to: 'carts#remove'

  # Root route
  root 'home#index'
end
