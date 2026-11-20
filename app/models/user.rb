class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  validates :email, presence: true
  validates :google_sub, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 200 }
  validates :phone, presence: true, phone: true

  normalizes :phone, with: ->(value) do
    phone = Phonelib.parse(value)
    phone.valid? ? phone.e164 : value
  end
  normalizes :email, with: ->(value) { value.strip.downcase }
  normalizes :name, with: ->(value) { value.strip }
end
