require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:subscriber).class_name('User') }
  it { should belong_to :publisher }

  subject { FactoryBot.build(:subscription) }
  it { should validate_uniqueness_of(:subscriber).scoped_to([:publisher_id, :publisher_type]) }
end
