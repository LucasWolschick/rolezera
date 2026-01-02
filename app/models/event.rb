class Event < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic

  scope :active, -> { where("expires_at > ?", Time.current) }

  after_commit :notify_friends, on: :create

  def self.create_for(inviter:, topic:)
    Event.create!(inviter: inviter, event_topic_id: topic.id, expires_at: Time.now + 30.minutes)
  end

  def self.get_for(user, inviter: user)
    active.where(inviter: user).first
  end

  def format_message
    event_topic.prompt % { user_name: inviter.name }
  end

  def notify_friends
    inviter.friends.each do |friend|
      friend.push_subscriptions.each do |subscription|
        WebPushJob.perform_later(self, subscription)
      end
    end
  end
end
