Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope "/v1" do
    use_doorkeeper do
      skip_controllers :applications,
        :authorizations,
        :authorized_applications
    end
  end

  # devise_for :users,
  #            controllers: {
  #              omniauth_callbacks: 'v1/user/omniauth_callbacks'
  #            },
  #            format: false,
  #            path: 'v1/oauth'

  namespace :v1, defaults: {format: :json} do
    get "/oauth/google/callback", to: "oauth/callbacks#google"

    # jsonapi_resources :copies, only: [:index, :show] do
    # end

    # jsonapi_resources :expansions, only: [:index, :show] do
    # end

    # jsonapi_resources :games, only: [:index, :show] do
    #   jsonapi_related_resources :expansions, only: [:index] do
    #   end
    # end

    resources :copies, only: %i[index show update] do
      scope module: :copy do
        resources :owners, only: [:index]
        resources :ownerships, only: %i[index create]
      end
    end

    # resources :expansions, only: %i[index show] do
    #   scope module: :expansion do
    #     resources :copies, only: %i[index create]
    #     resources :expandables, only: [:index]
    #     resources :expansions, only: [:index]
    #     resources :holders, only: [:index]
    #     resources :owners, only: [:index]
    #     resources :ownerships, only: [:index]
    #     resources :versions, only: [:index]
    #   end
    # end

    # resources :games, only: %i[index show] do
    #   scope module: :game do
    #     resources :copies, only: %i[index create]
    #     resources :expansions, only: [:index]
    #     resources :holders, only: [:index]
    #     resources :owners, only: [:index]
    #     resources :ownerships, only: [:index]
    #     resources :versions, only: [:index]
    #   end
    # end

    # resources :holders do
    #   scope module: :holder do
    #     resources :copies, only: [:index]
    #     resources :expansions, only: [:index]
    #     resources :games, only: [:index]
    #   end
    # end

    # resources :owners do
    #   scope module: :owner do
    #     resources :copies, only: [:index]
    #     resources :expansions, only: [:index]
    #     resources :games, only: [:index]
    #     resources :ownerships, only: [:index]
    #   end
    # end

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
