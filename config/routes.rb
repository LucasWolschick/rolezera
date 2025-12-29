Rails.application.routes.draw do
  # landing page
  root to: "landing_page#index"

  # login/signup flow
  post "/auth", to: "auth#create"
  delete "/auth", to: "auth#destroy"
  resources :sign_up, path: "/signup", only: [ :index, :create ]

  # main application
  get "/home", to: "home#index"
end
