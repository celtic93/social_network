FactoryBot.define do
  factory :comment do
    body { "Comment Body" }
    user

    trait :invalid do
      body { nil }
    end
  end
end
