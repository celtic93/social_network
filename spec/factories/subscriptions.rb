FactoryBot.define do
  factory :subscription do
    association :subscriber, factory: :user
    association :publisher, factory: :user
  end
end
