class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: true

  def author?(resource)
    id == resource.user_id
  end
end
