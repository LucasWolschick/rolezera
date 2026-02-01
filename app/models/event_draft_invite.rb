class EventDraftInvite < ApplicationRecord
  belongs_to :event_draft
  belongs_to :user

  validates :user, uniqueness: { scope: :event_draft, message: "only one invite per user per event" }
end
