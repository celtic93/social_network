class Post < ApplicationRecord
  belongs_to :user

  validates :body, presence: true

  default_scope { order(created_at: :desc) }
end
