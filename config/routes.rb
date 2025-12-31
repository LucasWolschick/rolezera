Rails.application.routes.draw do
  # landing page
  root to: "landing_page#index"

  # login/signup flow
  post "/auth", to: "auth#create"
  delete "/auth", to: "auth#destroy"
  resources :sign_up, path: "/signup", only: [ :index, :create ]

  # main application
  get "/home", to: "home#index"

  # friends
  get "/friends", to: "friends#index"
  get "/friends/add", to: "friends#add_friends"
  get "/friends/scan", to: "friends#scan_code"
  get "/friends/code", to: "friends#show_code"
  get "/friends/code/qr.svg", to: "friends#show_code_qr", as: :friends_code_qr

  resources :friend_invites, path: "/friends/invites", only: %i[ show ], param: :token do
    collection do
      post ":token", to: "friend_invites#create"
    end
  end
end
