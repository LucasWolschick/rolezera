class FriendsController < ApplicationController
  def index
    @friends = Current.user.friends.all
  end

  def show
    @user = Current.user.friends.find(params[:id])
    render layout: false
  end

  def destroy
    friend = Current.user.friends.find(params[:id])

    if Current.user.friends.include?(friend)
      Current.user.remove_friend(friend)
      redirect_to friends_path
    end
  end

  def add_friends
  end

  def scan_code
  end

  def show_code
    @invite = FriendInvite.get_or_create_for(Current.user)
  end

  def show_code_qr
    invite = FriendInvite.get_or_create_for(Current.user)
    return head :not_found unless invite

    qr_svg = helpers.build_qr_code(invite.token)

    send_data qr_svg.to_s, type: "image/svg+xml", disposition: "inline"
  end

  def confirm_remove
    @user = User.find(params[:id])
    render layout: false
  end
end
