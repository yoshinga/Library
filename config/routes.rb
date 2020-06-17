Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, except: [:index]
  resources :books
  resources :publishers
  resources :comments, only: [:create, :update, :destroy]
end
