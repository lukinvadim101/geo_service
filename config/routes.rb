Rails.application.routes.draw do
  resources :locations, only: [:index, :create, :show, :destroy]

  root "locations#index"
end
