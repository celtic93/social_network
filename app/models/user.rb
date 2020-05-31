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
  has_many :friendship_requests, ->(user) { unscope(where: :user_id).where("requestor_id = ? OR receiver_id = ?", user.id, user.id) }
  has_many :requested_friends, ->(user) { where("receiver_id != ?", user.id) },
                               through: :friendship_requests,
                               source: :receiver
  has_many :pending_friends, ->(user) { where("requestor_id != ?", user.id) },
                             through: :friendship_requests,
                             source: :requestor

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  def author?(resource)
    id == resource.user_id
  end

  def liked?(resource)
    likes.exists?(likeable: resource)
  end
end
