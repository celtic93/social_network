class User < ApplicationRecord
  include Publisher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments
  has_many :likes
  has_many :friendships, ->(user) { unscope(where: :user_id).where("friend_a_id = ? OR friend_b_id = ?", user.id, user.id) }
  has_many :friends_a, ->(user) { unscope(where: :user_id).where("friend_a_id != ?", user.id) },
                       through: :friendships,
                       source: :friend_a
  has_many :friends_b, ->(user) { where("friend_b_id != ?", user.id) },
                       through: :friendships,
                       source: :friend_b
  has_many :friendship_requests, ->(user) { unscope(where: :user_id).where("requestor_id = ? OR receiver_id = ?", user.id, user.id) }
  has_many :requested_friends, ->(user) { unscope(where: :user_id).where("receiver_id != ?", user.id) },
                               through: :friendship_requests,
                               source: :receiver
  has_many :pending_friends, ->(user) { unscope(where: :user_id).where("requestor_id != ?", user.id) },
                             through: :friendship_requests,
                             source: :requestor
  has_many :communities
  has_many :subscriptions, foreign_key: :subscriber_id
  has_many :followed_users, through: :subscriptions, source: :publisher, source_type: 'User'
  has_many :followed_communities, through: :subscriptions, source: :publisher, source_type: 'Community'

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  def author?(resource)
    id == resource.user_id
  end

  def liked?(resource)
    likes.exists?(likeable: resource)
  end

  def friends
    friends_a + friends_b
  end

  def subscribed?(publisher)
    subscriptions.exists?(publisher: publisher)
  end

  def news
    Post.where("(publisher_id IN (?) AND publisher_type = 'User') OR
                (publisher_id IN (?) AND publisher_type = 'Community')",
                followed_user_ids, followed_community_ids).order(created_at: :desc)
  end

  def self.search(query)
    where('firstname LIKE ? OR lastname LIKE ? OR username LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%") unless query.blank?
  end
end
