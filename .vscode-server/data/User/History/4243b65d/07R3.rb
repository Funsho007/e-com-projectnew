Rails.application.routes.draw do
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'index', to: 'checkout#index', as: 'checkout_index'
    get 'guest', to: 'checkout#guest', as: 'checkout_guest'
    post 'save_guest_address', to: 'checkout#save_guest_address', as: 'save_guest_address'
  end

  resources :customers, only: [:show]
  devise_for :customers

  get 'home/index'

  get 'page/:permalink', to: 'pages#show', as: 'page'
  resources :pages, only: [:edit, :update], param: :permalink
  get '/contact', to: 'pages#show', defaults: { permalink: 'contact' }
  get '/about', to: 'pages#show', defaults: { permalink: 'about' }
  post '/contact', to: 'contacts#create', as: 'contact_submit'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :orders, only: [:index, :show]

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

  get 'cart', to: 'carts#show'
  put 'cart/update', to: 'carts#update'
  delete 'cart/remove', to: 'carts#remove'
  get 'pages/:permalink', to: 'pages#permalink', as: 'permalink'

  root 'home#index'
end
