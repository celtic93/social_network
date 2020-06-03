require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to(:friend_a).class_name('User') }
  it { should belong_to(:friend_b).class_name('User') }

  subject { FactoryBot.build(:friendship) }
  it { should validate_uniqueness_of(:friend_a_id).scoped_to(:friend_b_id) }
end
