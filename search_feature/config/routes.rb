Rails.application.routes.draw do
  root "movies#index"

  resources :movies, only: [:index, :show]
  resources :actors, only: [:index, :show]
end
