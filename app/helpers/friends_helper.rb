module FriendsHelper
  def build_qr_code(token)
    RQRCode::QRCode.new(friend_invite_url(token)).as_svg(
      offset: 11,
      color: "000",
      shape_rendering: "crispEdges",
      standalone: true
    )
  end

  def whatsapp_link_for_user(user)
    "https://wa.me/#{user.phone}"
  end
end
