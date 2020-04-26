require 'rails_helper'

feature 'User can delete profile' do
  given(:user) { create(:user) }

  scenario 'Authenticated user tryes to delete his profile' do
    sign_in(user)
    click_on 'Edit profile'
    click_on 'Delete profile'

    expect(page).to have_content 'Your profile successfully deleted.'
    expect(page).to have_content 'Sign up'
  end
end
