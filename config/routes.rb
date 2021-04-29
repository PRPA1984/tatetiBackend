Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :boards, only: [] do
    collection do
      post :newGame
    end

    member do
      post :newTurn
    end
  end
end
