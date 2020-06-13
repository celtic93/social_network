FactoryBot.define do
  factory :post do
    body { 'Post body' }
    association :publisher, factory: :user
    user { publisher }

    trait :invalid do
      body { nil }
    end
  end
end
