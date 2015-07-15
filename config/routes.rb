Rails.application.routes.draw do
  root 'welcome#index'

  resources :duel, only: [ :show, :create ] do
    member do
      post 'defend'
      post 'ability'
      post 'declare_attackers'
      post 'game_action'
    end

    resources :player, only: [ :show ] do
      resources :hand, only: [ :show ] do
        member do
          post 'play'
        end
      end
    end

  end

  resources :premade_decks, only: [ :index, :show ]

  resources :cards, only: [ :index, :show ]

  get "/auth/google_login/callback" => "sessions#create"
  get "/logout" => "sessions#destroy", :as => :logout

  get 'sessions/new', :as => :login
end
