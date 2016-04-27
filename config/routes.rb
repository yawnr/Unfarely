Rails.application.routes.draw do
  root 'best_flights#index'
  resources :alerts, only: [:index, :new, :create, :update, :destroy]
  resources :best_flights, only: [:index, :show, :create, :update, :destroy]
  resources :flights, only: [:index, :show, :create, :destroy]
  resources :countries, only: [:create]
  resources :cities, only: [:index, :show, :create]
  resources :airports, only: [:index, :show, :create, :destroy]
  resources :users, only: [:new, :create, :show, :update]
  resource :session, only: [:new, :create, :destroy]
end
