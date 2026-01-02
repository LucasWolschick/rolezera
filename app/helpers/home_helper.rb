module HomeHelper
  def any_friend_with_event?
    Current.user.friends.joins(:events).exists?
  end
end
