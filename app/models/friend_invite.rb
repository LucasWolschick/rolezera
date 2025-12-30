class FriendInvite < ApplicationRecord
  belongs_to :inviter, class_name: "User"

  validates :token, presence: true

  scope :active, -> { where("expires_at > ?", Time.current) }

  def self.resolve(token)
    active
      .where(token: token)
      .first
  end

  def self.get_or_create_for(inviter, expires_in = 15.minutes)
    if invite = active.where(inviter: inviter).first
      return invite
    end

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
