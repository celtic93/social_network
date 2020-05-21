FactoryBot.define do
  factory :like do
    association :likeable, factory: :post
    user
  end
end
