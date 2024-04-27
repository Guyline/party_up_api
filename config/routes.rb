Rails.application.routes.draw do
  devise_for :users,
             controllers: { omniauth_callbacks: 'auth/callback' },
             path: '',
             skip: %i[
               passwords
               registrations
               sessions
             ]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :v1 do
    defaults format: :json do
      resources :copies, only: %i[index show update] do
        scope module: :copy do
          resources :owners, only: [:index]
          resources :ownerships, only: %i[index create]
        end
      end

      resources :games, only: %i[index show] do
        scope module: :game do
          resources :copies, only: %i[index create]
          resources :holders, only: [:index]
          resources :owners, only: [:index]
          resources :ownerships, only: [:index]
          resources :versions, only: [:index]
        end
      end

      resources :ownerships, only: %i[index show destroy]

      resources :users, only: %i[index show] do
        scope module: :user do
          resources :copies, only: [:index]
          resources :held_games, only: [:index]
          resources :owned_games, only: [:index]
          resources :ownerships, only: [:index]
        end
      end

      resources :versions, only: %i[index show] do
        scope module: :version do
          resources :copies, only: %i[index create]
          resources :holders, only: [:index]
          resources :owners, only: [:index]
          resources :ownerships, only: [:index]
        end
      end
    end
  end
end
