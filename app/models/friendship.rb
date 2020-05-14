class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: :friend_id }
  validates :friend_id, uniqueness: { scope: :user_id }

  def self.requested?(user, friend)
    find_by(user: user, friend: friend).present?
  end

  def self.request(user, friend)
    unless user == friend or Friendship.requested?(user, friend)
      transaction do
        create(user: user, friend: friend, :status => 'pending')
        create(user: friend, friend: user, :status => 'requested')
      end
    end
  end

  def self.accept(user, friend)
    transaction do
      accept_one_side(user, friend)
      accept_one_side(friend, user)
    end
  end

  def self.breakup(user, friend)
    transaction do
      find_by(user: user, friend: friend).destroy
      find_by(user: friend, friend: user).destroy
    end
  end

  private

  def self.accept_one_side(user, friend)
    request = find_by(user: user, friend: friend)
    request.status = 'accepted'
    request.save!
  end
end
