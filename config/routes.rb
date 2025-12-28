Rails.application.routes.draw do
  # landing page
  root to: "landing_page#index"

  # login/signup flow
  get "/auth", to: "auth#index"
  resources :sign_up, path: "/signup", only: [ :index, :create ]

  # main application
  get "/home", to: "home#index"
end
