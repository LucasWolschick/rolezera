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

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :events, dependent: :destroy

  def friends
    super.readonly
  end

  def add_friend(other)
    return if other.id == id

    transaction do
      friendships.create!(friend: other)
      other.friendships.create!(friend: self)
    end
  end

  def remove_friend(other)
    transaction do
      friendships.where(friend: other).destroy_all
      other.friendships.where(friend: self).destroy_all
    end
  end
end
