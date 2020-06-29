Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, except: [:index]
  resources :books do
    member do
      patch :rent_book, as: 'rent'
      patch :return_book, as: 'return'
    end
    collection do
      post :predictive_search
      post :create_book_search
    end
  end
  resources :publishers
  resources :comments, only: [:show, :create, :update, :destroy]
  resources :wish_lists
end
