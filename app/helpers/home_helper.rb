module HomeHelper
  def any_friend_with_event?
    Current.user.friends.joins(:active_events).exists?
  end
end
