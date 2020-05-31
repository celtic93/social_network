require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it { should belong_to :user }
  it { should belong_to(:friend).class_name('User') }

  subject { FactoryBot.build(:friendship) }
  it { should validate_presence_of :status }
  it { should validate_uniqueness_of(:user_id).scoped_to(:friend_id) }

  let(:users) { create_list(:user, 2) }
  let!(:friendship) { create(:friendship, :requested) }
  let!(:friendship_2) { create(:friendship, :pending,
                                           user: friendship.friend,
                                           friend: friendship.user) }
  let(:friend) { friendship.user }
  let(:friend_2) { friendship.friend }

  describe '#requested?' do
    it 'checks precence of friendship in database' do
      expect(Friendship).to be_requested(friend, friend_2)
      expect(Friendship).to_not be_requested(users[0], friend)
    end
  end

  describe '#request' do
    context 'for not friends' do
      before { Friendship.request(users[0], users[1]) }

      it 'creates friendships for users' do
        expect(users[1].requested_friends).to include(users[0])
        expect(users[0].pending_friends).to include(users[1])
      end
    end

    context 'for one user' do
      before { Friendship.request(users[0], users[0]) }

      it 'does not create friendships for user' do
        expect(users[0].friends).to_not include(users[0])
        expect(users[0].requested_friends).to_not include(users[0])
        expect(users[0].pending_friends).to_not include(users[0])
      end
    end

    context 'for users with requested friendship' do
      before { Friendship.request(friend, friend_2) }

      it 'does not change friendships for users' do
        expect(friend.requested_friends).to include(friend_2)
        expect(friend_2.pending_friends).to include(friend)
        expect(friend.friends).to_not include(friend_2)
        expect(friend_2.friends).to_not include(friend)
      end
    end
  end

  describe '#accept' do
    context 'for users with requested friendship' do
      before { Friendship.accept(friend, friend_2) }

      it 'makes users friends' do
        expect(friend.requested_friends).to_not include(friend_2)
        expect(friend_2.pending_friends).to_not include(friend)
        expect(friend.friends).to include(friend_2)
        expect(friend_2.friends).to include(friend)
      end
    end

    context 'for one user' do
      before { Friendship.accept(users[0], users[0]) }

      it 'does not make user a friend to himself' do
        expect(users[0].friends).to_not include(users[0])
        expect(users[0].requested_friends).to_not include(users[0])
        expect(users[0].pending_friends).to_not include(users[0])
      end
    end

    context 'for not friends' do
      before { Friendship.accept(users[0], users[1]) }

      it 'do not create friendships for users' do
        expect(users[1].requested_friends).to_not include(users[0])
        expect(users[0].pending_friends).to_not include(users[1])
        expect(users[1].friends).to_not include(users[0])
        expect(users[0].friends).to_not include(users[1])
      end
    end
  end

  describe '#accept' do
    context 'for users with requested friendship' do
      before { Friendship.breakup(friend, friend_2) }

      it 'deletes friendship from database' do
        expect(friend.requested_friends).to_not include(friend_2)
        expect(friend_2.pending_friends).to_not include(friend)
        expect(friend.friends).to_not include(friend_2)
        expect(friend_2.friends).to_not include(friend)
      end
    end

    context 'for friends' do
      before do
        Friendship.accept(friend, friend_2)
        Friendship.breakup(friend, friend_2)
      end

      it 'deletes friendship from database' do
        expect(friend.requested_friends).to_not include(friend_2)
        expect(friend_2.pending_friends).to_not include(friend)
        expect(friend.friends).to_not include(friend_2)
        expect(friend_2.friends).to_not include(friend)
      end
    end
  end
end
