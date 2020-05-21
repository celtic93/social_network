class Post < ApplicationRecord
  include Commentable
  include Likeable
  
  belongs_to :user

  validates :body, presence: true

  default_scope { order(created_at: :desc) }
end
