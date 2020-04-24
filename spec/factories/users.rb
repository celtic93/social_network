FactoryBot.define do
  sequence :firstname do |n|
    "Firstname#{n}"
  end

  sequence :lastname do |n|
    "Lastname#{n}"
  end

  sequence :username do |n|
    "username#{n}"
  end

  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :info do |n|
    "user#{n} info"
  end

  factory :user do
    firstname
    lastname
    username
    email
    info
    password { '12345678' }
  end
end
