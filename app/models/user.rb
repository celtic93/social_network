class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :likes
  has_many :friendships
  has_many :friends, -> { where(friendships: {status: 'accepted'}) },
                     through: :friendships
  has_many :requested_friends, -> { where(friendships: {status: 'requested'}) },
                               through: :friendships,
                               source: :friend
  has_many :pending_friends, -> { where(friendships: {status: 'pending'}) },
                                  through: :friendships,
                                  source: :friend

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  def author?(resource)
    id == resource.user_id
  end

  def liked?(resource)
    likes.exists?(likeable: resource)
  end
end
