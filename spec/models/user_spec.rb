require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'publisher'

  describe 'validations' do
    it { should have_many :posts }
    it { should have_many :comments }
    it { should have_many :likes }
    it { should have_many :communities }
    it { should have_many(:subscriptions).with_foreign_key(:subscriber_id) }

    it { should validate_presence_of :firstname }
    it { should validate_presence_of :lastname }
    it { should validate_presence_of :username }

    subject { FactoryBot.build(:user) }
    it { should validate_uniqueness_of :username }
  end

  let(:users) { build_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let(:post) { create(:post, user: user) }
  let(:other_post) { create(:post, user: other_user) }
  let(:like) { create(:like, user: user, likeable: post) }
  let(:other_like) { create(:like) }
  let!(:friendship_1) { create(:friendship, friend_a: user) }
  let!(:friendship_2) { create(:friendship, friend_b: user) }
  let(:other_friendship) { create(:friendship) }
  let(:friendship_request_1) { create(:friendship_request, requestor: user) }
  let(:friendship_request_2) { create(:friendship_request, receiver: user) }
  let(:other_friendship_request) { create(:friendship_request) }
  let(:subscription_for_user) { create(:subscription, subscriber: user) }
  let(:communities) { create_list(:community, 2) }
  let!(:subscription_for_community) { create(:subscription, subscriber: user, publisher: communities[0]) }
  let!(:followed_user_post) { create(:post, publisher: subscription_for_user.publisher) }
  let!(:followed_community_post) { create(:post, publisher: communities[0], user: communities[0].user) }
  
  it 'should have many friendships' do
    expect(user.friendships).to eq [friendship_1, friendship_2]
  end

  it 'should have many friends_a' do
    expect(user.friends_a).to eq [friendship_2.friend_a]
  end

  it 'should have many friends_b' do
    expect(user.friends_b).to eq [friendship_1.friend_b]
  end

  it 'should have many friendship_requests' do
    expect(user.friendship_requests).to eq [friendship_request_1, friendship_request_2]
  end

  it 'should have many requested_friends' do
    expect(user.requested_friends).to eq [friendship_request_1.receiver]
  end

  it 'should have many pending_friends' do
    expect(user.pending_friends).to eq [friendship_request_2.requestor]
  end

  it 'should have many followed_users' do
    expect(user.followed_users).to eq [subscription_for_user.publisher]
  end

  it 'should have many followed_communities' do
    expect(user.followed_communities).to eq [communities[0]]
  end

  describe '.author?' do
    it 'verifies the authorship of the resource' do
      expect(user).to be_author(post)
      expect(other_user).to_not be_author(post)
    end
  end

  describe '.liked?' do
    it 'checks that the user liked the resource' do
      expect(user).to be_liked(like.likeable)
      expect(user).to_not be_liked(other_like.likeable)
    end
  end

  describe '.friends' do
    it 'shows a list of friends' do
      expect(user.friends).to eq [friendship_2.friend_a, friendship_1.friend_b]
    end
  end

  describe '.news' do
    it 'shows a list of followed users and communities posts' do
      expect(user.news).to eq [followed_community_post, followed_user_post]
    end
  end
end
