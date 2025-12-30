class FriendInvite < ApplicationRecord
  belongs_to :inviter, class_name: "User"

  validates :token, presence: true

  def self.resolve(token)
    FriendInvite
      .where(token: token)
      .where("expires_at > ?", Time.current)
      .first
  end

  def self.create_for(inviter, expires_in = 15.minutes)
    expiry = Time.current + expires_in

    begin
      create!(
        inviter: inviter,
        token: SecureRandom.urlsafe_base64(32),
        expires_at: expiry
      )
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
