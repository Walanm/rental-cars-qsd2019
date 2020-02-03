Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :manufacturers, only: [:index, :show, :new, :create, :edit, :update]
  resources :subsidiaries, :car_categories
  resources :car_models, only: [:index, :show, :new, :create, :edit, :update]
  resources :clients, only: [:index, :show, :new, :create]
  resources :rentals, only: [:index, :show, :new, :create] do
    get 'search', on: :collection
    resources :car_rentals, only: [:new, :create]
  end
  resources :cars, only: [:index, :show, :new, :create]

  namespace :api do
    namespace :v1 do
      resources :cars, only: [:index, :show, :create] do
        patch 'status/:status', to: 'cars#status', on: :member, as: :status
      end
      resources :rentals, only: [:create]
    end
  end
end
