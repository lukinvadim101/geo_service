Rails.application.routes.draw do
  resources :locations, only: [:index, :create]

  root "locations#index"
end
