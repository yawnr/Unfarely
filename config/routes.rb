Rails.application.routes.draw do
  root to: "static_pages#root"
  resources :users, only: [:new, :create, :show, :update]
  resource :session, only: [:new, :create, :destroy]
  resources :trips
  resources :best_flights, only: [:index, :show, :create, :update, :destroy]
  resources :alerts, only: [:index, :new, :create, :update, :destroy]
  resources :flights, only: [:index, :show, :create, :destroy]
  resources :airports, only: [:index, :show, :create, :destroy]
  resources :cities, only: [:index, :show, :create]
  resources :countries, only: [:create]
end
