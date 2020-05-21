require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :likeable }
  it { should belong_to :user }

  let(:post) { create(:post) }
  let(:user) { post.user }
  let!(:like) { create(:like, user: user, likeable: post) }

  it 'should validate uniquesness of like' do
    like2 = Like.new(user: user, likeable: post)
    expect(like2).not_to be_valid
  end
end
