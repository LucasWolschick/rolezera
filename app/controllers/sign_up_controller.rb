class SignUpController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_logged_in
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to sign_up_path, alert: "Try again later." }

  def index
    redirect_to root_path unless session[:pending_oidc]

    @user = User.new(email: session[:pending_oidc]["email"], name: "", phone: "")
  end

  def create
    pending = session[:pending_oidc]
    redirect_to root_path and return unless pending

    @user = User.new(
      email: pending["email"],
      google_sub: pending["sub"],
      name: user_params[:name],
      phone: user_params[:phone]
    )

    if @user.save
      session[:user_id] = @user.id
      session.delete(:pending_oidc)

      redirect_to home_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.expect(user: [ :name, :phone ])
  end
end
