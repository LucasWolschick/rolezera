class SignUpController < ApplicationController
  include OidcSession
  unauthenticated_access_only
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to sign_up_index_path, alert: "Try again later." }

  def index
    redirect_to root_path unless pending_oidc

    @user = User.new(email: pending_oidc[:email], name: "", phone: "")
  end

  def create
    pending = pending_oidc
    redirect_to root_path and return unless pending

    @user = User.new(
      email: pending[:email],
      google_sub: pending[:sub],
      name: user_params[:name],
      phone: user_params[:phone]
    )

    if @user.save
      start_new_session_for user
      clear_pending_oidc

      redirect_to after_authentication_url
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.expect(user: [ :name, :phone ])
  end
end
