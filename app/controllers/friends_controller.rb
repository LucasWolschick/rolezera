class FriendsController < ApplicationController
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
end
