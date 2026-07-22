Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  use_doorkeeper scope: "v1" do
    controllers tokens: "v1/oauth/access_tokens"
    skip_controllers :applications,
      :authorizations,
      :authorized_applications
  end

  namespace :v1, defaults: {format: :json} do
    # post "/oauth/user-token", to: "oauth/access_tokens#create_user_token"
    get "/oauth/callback/google", to: "oauth/callbacks#google"

    # post :access_tokens, to: "oauth/access_tokens#create"

    resources :copies, only: %i[index show update] do
      scope module: :copy do
        resources :owners, only: [:index]
        resources :ownerships, only: %i[index create]
      end
    end

    resources :ownerships, only: %i[index show destroy]

    resources :items, only: %i[index show] do
      scope module: :item do
        resources :copies, only: %i[index create]
        resources :expandables, only: [:index]
        resources :expansions, only: [:index]
        resources :holders, only: %i[index]
        resources :owners, only: [:index]
        resources :ownerships, only: [:index]
        resources :versions, only: [:index]
      end
    end

    resources :users, only: %i[index show] do
      scope module: :user do
        resources :copies, only: [:index]
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
