module HomeHelper
  def any_friend_with_event?
    Current.user.visible_events.active.exists?
  end
end
