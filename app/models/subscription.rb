class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :publisher, polymorphic: true

  validates :subscriber, uniqueness: { scope: [:publisher_id, :publisher_type] }
end
