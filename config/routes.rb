Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :entities, only: [:index, :create]
  resources :transactions, only: [] do
    collection do
      post :deposit
      post :withdraw
      post :transfer
    end
  end

  root 'landing#index'
end
