class LandingPageController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_if_logged_in

  def index
  end
end
