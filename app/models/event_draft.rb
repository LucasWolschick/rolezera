class EventDraft < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :event_topic

  has_many :event_draft_invites, dependent: :destroy

  def publish
    event = Event.create_for(inviter, event_topic)
    destroy
    event
  end
end
