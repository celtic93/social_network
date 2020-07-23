require 'rails_helper'

RSpec.describe Community, type: :model do
  it_behaves_like 'publisher'
  
  it { should belong_to :user }

  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
end
