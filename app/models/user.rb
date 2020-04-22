class User < ApplicationRecord
  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true
end
