FactoryBot.define do
  factory :user do
    firstname { 'John' }
    lastname { 'Smith' }
    username { 'johnsmith69' }
    email { 'johnsmith69@gmail.com' }
    password { '12345678' }
  end
end
