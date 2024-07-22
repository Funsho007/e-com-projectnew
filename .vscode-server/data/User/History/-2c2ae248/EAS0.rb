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
