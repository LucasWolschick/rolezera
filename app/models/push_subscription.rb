class PushSubscription < ApplicationRecord
  belongs_to :user
  validates :endpoint, uniqueness: true
end
