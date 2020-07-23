class Community < ApplicationRecord
  include Publisher
  
  belongs_to :user

  validates :name, :description, presence: true
end
