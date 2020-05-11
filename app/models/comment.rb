class Comment < ApplicationRecord
  include Likeable
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
