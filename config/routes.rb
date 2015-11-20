Rails.application.routes.draw do
  root 'welcome#index'

  resources :duel, only: [ :show, :create ] do
    get 'action_log'
    get 'stack'

    resources :player, only: [ :show ] do
      member do
        get 'actions'
        get 'deck'
        get 'battlefield'
        get 'hand'
        get 'graveyard'
        post 'game_action'
        post 'declare_attackers'
        post 'request_pass'
        post 'ping'

        # TODO resource :deck, only: [ :show ]
      end

      resources :hand, only: [ :show ] do
        member do
          post 'play'
        end
      end

      resources :battlefield, only: [ :show ] do
        member do
          post 'ability'
          post 'defend'
        end
      end
    end
  end

  resources :user, only: [ :show ] do
    resources :duel_request, only: [ :create, :index ]
  end

  resources :premade_decks, only: [ :index, :show ]

  resources :cards, only: [ :index, :show ]

  get "/card-styles" => "cards#styles"

  get "/auth/google_login/callback" => "sessions#create"
  get "/logout" => "sessions#destroy", :as => :logout

  get "sessions/new", :as => :login
  post "sessions/emulated_login"
end
