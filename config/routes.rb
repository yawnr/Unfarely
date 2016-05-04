Rails.application.routes.draw do
  root to: "static_pages#root"
  resources :users, only: [:new, :create, :show, :update]
  resource :session, only: [:new, :create, :destroy]

  namespace :api, defaults: {format: :json} do
    resources :trips
    resources :best_flights, only: [:index, :show, :create, :update, :destroy]
    resources :alerts, only: [:index, :new, :create, :update, :destroy]
    resources :airports, only: [:index, :show, :create, :destroy]
    resources :cities, only: [:index, :show, :create, :destroy]
    resources :countries, only: [:index, :show, :create, :destroy]
  end

  resources :flights, only: [:index, :show, :create, :destroy]
end
