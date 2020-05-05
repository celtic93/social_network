require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'commentable'

  it { should belong_to :user }
  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let!(:posts) { create_list(:post, 2, user: user) }

  context '.default_scope' do
    it 'should sort array starting with newest' do
      expect(user.posts.to_a).to be_eql [posts[1], posts[0]]
    end
  end
end
