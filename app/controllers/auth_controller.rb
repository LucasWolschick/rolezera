class AuthController < ApplicationController
  include OidcSession

  unauthenticated_access_only except: [ :destroy ]

  def index
    # todo: actually get data from google
    sub = "1"
    email = "example@gmail.com"

    user = User.find_by(google_sub: sub)

    if user
      start_new_session_for user
      redirect_to after_authentication_url
    else
      set_pending_oidc sub: sub, email: email
      redirect_to sign_up_index_path
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, status: :see_other
  end
end
