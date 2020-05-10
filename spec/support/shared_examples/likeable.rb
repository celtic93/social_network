require 'rails_helper'

shared_examples_for 'likeable' do
  it { should have_many(:likes).dependent(:destroy) }  
end
