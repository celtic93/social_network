FactoryBot.define do
  factory :friendship do
    user
    association :friend, factory: :user
    status { 'accepted' }

    trait :requested do
      status { 'requested' }
    end

    trait :pending do
      status { 'pending' }
    end
  end
end
