Rails.application.routes.draw do
  scope '/checkout' do
    post 'create', to: 'checkout#create', as: 'checkout_create'
    get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'success', to: 'checkout#success', as: 'checkout_success'
    get 'index', to: 'checkout#index', as: 'checkout_index'
    get 'guest', to: 'checkout#guest', as: 'checkout_guest'
    post 'save_guest_address', to: 'checkout#save_guest_address', as: 'save_guest_address'

  end

  resources :customer, only: [:show]
  devise_for :customers
  get 'home/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # get 'carts/show'
  # get 'carts/update'
  # get 'carts/remove'
  # get 'products/index'
  # get 'products/show'
  # get 'orders/index'
  # get 'orders/show'

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
      get "search"
    end

    member do
      post 'add_to_cart'
    end
  end

  get 'cart', to: 'carts#show'
  put 'cart/update', to: 'carts#update'
  delete 'cart/remove', to: 'carts#remove'
  get 'pages/:permalink', to: 'pages#permalink', as: 'permalink'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "home#index"
   
end
