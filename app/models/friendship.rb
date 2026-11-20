class Friendship < ApplicationRecord
  belongs_to :user, counter_cache: :friends_count
  belongs_to :friend, class_name: "User"

  validate :no_self_friendship

  def no_self_friendship
    errors.add(:base, "Invalid friendship") if user_id == friend_id
  end
end
