FactoryBot.define do
  factory :friendship_request do
    association :requestor, factory: :user
    association :receiver, factory: :user
  end
end
