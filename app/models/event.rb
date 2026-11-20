class Event < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic

  scope :active, -> { where("expires_at > ?", Time.current) }

  after_commit :notify_friends, on: :create

  has_many :event_invites, dependent: :destroy
  has_many :invited, through: :event_invites, source: :user

  def format_message
    event_topic.prompt % { user_name: inviter.name }
  end

  def notify_friends
    invited.each do |friend|
      friend.push_subscriptions.each do |subscription|
        WebPushJob.perform_later(self, subscription)
      end
    end
  end
end
