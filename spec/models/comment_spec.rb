require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'likeable'
  
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }
end
