FactoryBot.define do
  factory :post do
    body { 'Post body' }
    user

    trait :invalid do
      body { nil }
    end
  end
end
