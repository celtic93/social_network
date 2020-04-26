require 'rails_helper'

feature 'User can sign in' do
  given (:user) { create(:user) }

  background { visit new_user_session_path }

  describe 'Registered user tryes to sign in' do
    scenario 'with valid attributes' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'with wrong email' do
      fill_in 'Email', with: 'user_wrong_email@test.com'
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'with wrong password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'user_wrong_password'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
