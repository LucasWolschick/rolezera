Rails.application.routes.draw do
  # landing page
  root to: "landing_page#index"

  # login/signup flow
  get "/auth", to: "auth#index"
  delete "/auth", to: "auth#destroy"
  resources :sign_up, path: "/signup", only: [ :index, :create ]

  # main application
  get "/home", to: "home#index"
end
