FactoryBot.define do
  factory :comment do
    body { "Comment Body" }
    association :commentable, factory: :post
    user

    trait :invalid do
      body { nil }
    end
  end
end
