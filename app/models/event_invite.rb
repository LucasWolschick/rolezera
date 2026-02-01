class EventInvite < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :user, uniqueness: { scope: :event, message: "only one invite per user per event" }
end
