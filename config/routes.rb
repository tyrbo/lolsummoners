Rails.application.routes.draw do
  root "ladders#index"

  resources :ladders, only: [:index]
end
