FactoryBot.define do
  factory :community do
    name { 'Community name' }
    description { 'Community description' }
    user

    trait :invalid do
      name { nil }
    end
  end
end
