class AuthController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_logged_in

  def index
    # todo: actually get data from google
    sub = "1"
    email = "example@gmail.com"

    user = User.find_by(google_sub: sub)

    if user
      # user authenticated
      session[:user_id] = user.id

      redirect_to home_path
    else
      # load google data
      session[:pending_oidc] = {
        "sub" => sub,
        "email" => email
      }

      redirect_to sign_up_index_path
    end
  end
end
