require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should have_many :posts }
    it { should validate_presence_of :firstname }
    it { should validate_presence_of :lastname }
    it { should validate_presence_of :username }

    subject { FactoryBot.build(:user) }
    it { should validate_uniqueness_of :username }
  end
end
