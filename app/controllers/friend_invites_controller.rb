class FriendInvitesController < ApplicationController
  before_action :set_user

  def show
  end

  def create
    if @user != nil && @user != Current.user && !Current.user.friends.include?(@user)
      Current.user.add_friend(@user)
      redirect_to friends_path
    else
      redirect_to friends_scan_path, status: :unprocessable_entity
    end
  end

  private
  def set_user
    @invite = FriendInvite.resolve(params[:token])
    @user = @invite&.inviter
  end
end
