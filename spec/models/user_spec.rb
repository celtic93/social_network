require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should have_many :posts }
    it { should have_many :comments }
    it { should have_many :likes }

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
end
