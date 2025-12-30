module FriendsHelper
  def build_qr_code(token)
    RQRCode::QRCode.new(token).as_svg(
      offset: 11,
      color: "000",
      shape_rendering: "crispEdges",
      standalone: true
    )
  end
end
