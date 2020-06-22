class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :publisher, polymorphic: true
end
