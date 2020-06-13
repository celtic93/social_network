module Publisher
  extend ActiveSupport::Concern

  included do
    has_many :publications, class_name: 'Post', as: :publisher, dependent: :destroy
  end
end
