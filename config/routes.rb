Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :market_vendors, only: [:create]
      resource :market_vendors, only: [:destroy]
      resources :vendors
      resources :markets, only: [:index, :show, :create] do
        resources :vendors, only: [:index], controller: :market_vendors
      end
    end
  end
end
