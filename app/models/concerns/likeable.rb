module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, dependent: :destroy, as: :likeable
  end
end
