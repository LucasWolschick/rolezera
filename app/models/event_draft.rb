class EventDraft < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic, optional: true

  has_many :event_draft_invites, dependent: :destroy
  has_many :invited, through: :event_draft_invites, source: :user

  def invite_count
    if invited_all
      inviter.friends_count
    else
      invited.count
    end
  end

  def publish
    event = Event.transaction do
      e = Event.create!(
        inviter: inviter,
        event_topic: event_topic,
        invited_all: invited_all,
        expires_at: Time.now + 30.minutes
      )

      unless invited_all
        event_draft_invites.find_each do |draft_invite|
          e.event_invites.create!(user: draft_invite.user)
        end
      end

      e
    end

    destroy
    event
  end
end
