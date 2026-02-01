class Event < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic

  scope :active, -> { where("expires_at > ?", Time.current) }

  after_commit :notify_friends, on: :create

  has_many :event_invites, dependent: :destroy
  has_many :invited, through: :event_invites, source: :user

  def self.get_for(inviter)
    active.where(inviter: inviter).first
  end

  def format_message
    event_topic.prompt % { user_name: inviter.name }
  end

  def notify_friends
    if invited_all?
      inviter.friends.each do |friend|
        friend.push_subscriptions.each do |subscription|
          WebPushJob.perform_later(self, subscription)
        end
      end
      return
    end

    invited.each do |friend|
      friend.push_subscriptions.each do |subscription|
        WebPushJob.perform_later(self, subscription)
      end
    end
  end
end
