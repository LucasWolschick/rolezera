class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :require_login

  private

  def require_login
    redirect_to root_path unless session[:user_id]
  end

  def redirect_if_logged_in
    redirect_to home_path if session[:user_id]
  end
end
