require 'rails_helper'

RSpec.describe FriendshipRequest, type: :model do
  it { should belong_to(:requestor).class_name('User') }
  it { should belong_to(:receiver).class_name('User') }

  subject { FactoryBot.build(:friendship_request) }
  it { should validate_uniqueness_of(:requestor_id).scoped_to(:receiver_id) }
end
