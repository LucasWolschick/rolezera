class LandingPageController < ApplicationController
  unauthenticated_access_only

  def index
    @hide_header = true
  end
end
