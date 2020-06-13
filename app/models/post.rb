class Post < ApplicationRecord
  include Commentable
  include Likeable
  
  belongs_to :user
  belongs_to :publisher, polymorphic: true

  validates :body, presence: true

  default_scope { order(created_at: :desc) }
end
