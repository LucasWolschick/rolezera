class EventDraftInvite < ApplicationRecord
  belongs_to :event_draft

  validates :user, uniqueness: { scope: :event_draft, message: "only one invite per user per event" }
end
