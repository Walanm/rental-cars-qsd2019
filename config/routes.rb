Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :manufacturers, only: %i[index show new create edit update]
  resources :subsidiaries
  resources :car_categories
  resources :car_models, only: %i[index show new create edit update]
  resources :clients, only: %i[index show new create]
  resources :rentals, only: %i[index show new create] do
    get 'search', on: :collection
    resources :car_rentals, only: %i[new create]
  end
  resources :cars, only: %i[index show new create]

  namespace :api do
    namespace :v1 do
      resources :cars, only: %i[index show create] do
        patch 'status/:status', to: 'cars#status', on: :member, as: :status
      end
      resources :rentals, only: [:create]
    end
  end
end
