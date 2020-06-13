require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'publisher'

  describe 'validations' do
    it { should have_many :posts }
    it { should have_many :comments }
    it { should have_many :likes }
    it { should have_many :communities }

    it { should validate_presence_of :firstname }
    it { should validate_presence_of :lastname }
    it { should validate_presence_of :username }

    subject { FactoryBot.build(:user) }
    it { should validate_uniqueness_of :username }
  end

  let(:users) { build_list(:user, 2) }
  let(:post) { create(:post, user: users[0]) }
  let(:like) { create(:like, user: users[0], likeable: post) }
  let(:other_like) { create(:like) }
  let!(:friendship_1) { create(:friendship, friend_a: users[0]) }
  let!(:friendship_2) { create(:friendship, friend_b: users[0]) }
  let(:other_friendship) { create(:friendship) }
  let(:friendship_request_1) { create(:friendship_request, requestor: users[0]) }
  let(:friendship_request_2) { create(:friendship_request, receiver: users[0]) }
  let(:other_friendship_request) { create(:friendship_request) }
  
  it 'should have many friendships' do
    expect(users[0].friendships).to eq [friendship_1, friendship_2]
  end

  it 'should have many friends_a' do
    expect(users[0].friends_a).to eq [friendship_2.friend_a]
  end

  it 'should have many friends_b' do
    expect(users[0].friends_b).to eq [friendship_1.friend_b]
  end

  it 'should have many friendship_requests' do
    expect(users[0].friendship_requests).to eq [friendship_request_1, friendship_request_2]
  end

  it 'should have many requested_friends' do
    expect(users[0].requested_friends).to eq [friendship_request_1.receiver]
  end

  it 'should have many pending_friends' do
    expect(users[0].pending_friends).to eq [friendship_request_2.requestor]
  end

  describe '.author?' do
    it 'verifies the authorship of the resource' do
      expect(users[0]).to be_author(post)
      expect(users[1]).to_not be_author(post)
    end
  end

  describe '.liked?' do
    it 'checks that the user liked the resource' do
      expect(users[0]).to be_liked(like.likeable)
      expect(users[0]).to_not be_liked(other_like.likeable)
    end
  end

  describe '.friends' do
    it 'shows a list of friends' do
      expect(users[0].friends).to eq [friendship_2.friend_a, friendship_1.friend_b]
    end
  end
end
