FactoryBot.define do
  factory :post do
    body { 'Post body' }
    user
  end
end
