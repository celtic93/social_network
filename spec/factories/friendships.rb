FactoryBot.define do
  factory :friendship do
    association :friend_a, factory: :user
    association :friend_b, factory: :user
  end
end
