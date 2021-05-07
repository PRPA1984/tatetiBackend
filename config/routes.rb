Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :boards, only: [:show] do
    collection do
      get :newGame
      get :lastBoard
      get :userState
    end

    member do
      post :newTurn
    end
  end

  resources :users, only: [:create] do
    collection do
      get :logout
      get :current
      get :matchHistory
      post :login
    end
  end
end
