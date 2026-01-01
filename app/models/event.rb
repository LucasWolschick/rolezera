class Event < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic

  scope :active, -> { where("expires_at > ?", Time.current) }

  def self.create_for(inviter:, topic:)
    Event.create!(inviter: inviter, event_topic_id: topic.id, expires_at: Time.now + 30.minutes)
  end

  def self.get_for(user, inviter: user)
    active.where(inviter: user).first
  end
end
