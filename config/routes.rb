Rails.application.routes.draw do
  # push notifications
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "/push_subscriptions", to: "push_subscriptions#subscribe"
  post "/push_subscriptions/status", to: "push_subscriptions#status"
  get "/push_subscriptions/cta", to: "push_subscriptions#cta"

  # landing page
  root to: "landing_page#index"

  # login/signup flow
  post "/auth", to: "auth#create"
  delete "/auth", to: "auth#destroy"
  resources :sign_up, path: "/signup", only: [ :index, :create ]

  # main application
  get "/home", to: "home#index"

  # friends
  get "/friends/add", to: "friends#add_friends"
  get "/friends/scan", to: "friends#scan_code"
  get "/friends/code", to: "friends#show_code"
  get "/friends/code/qr.svg", to: "friends#show_code_qr", as: :friends_code_qr
  get "/friends/remove/:id", to: "friends#confirm_remove", as: :friends_confirm_remove

  get "/friends", to: "friends#index"
  get "/friends/:id", to: "friends#show", as: :friend
  delete "/friends/:id", to: "friends#destroy"

  resources :friend_invites, path: "/friends/invites", only: %i[ show ], param: :token do
    collection do
      post ":token", to: "friend_invites#create"
    end
  end

  # events
  get "/events", to: "events#index"
  get "/events/join", to: "events#join"
  post "/events", to: "events#new"
  post "/events/confirm", to: "events#confirm"
end
