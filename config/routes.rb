Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :vendors
      resources :markets, only: [:index, :show, :create] do
        resources :vendors, only: [:index], controller: :market_vendors
      end
    end
  end
end
