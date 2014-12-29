Rails.application.routes.draw do
  root 'homes#index'
  devise_for :users
  resources :posts, only: [:new, :create, :show]

  resources :posts, only: [] do
    resources :comments, only: [:create]
  end
end
