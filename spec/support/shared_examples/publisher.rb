require 'rails_helper'

shared_examples_for 'publisher' do
  it { should have_many(:publications).class_name('Post').dependent(:destroy) }  
end
