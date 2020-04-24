require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  describe 'User tryes to sign up with' do
    background do
      fill_in 'Firstname', with: 'Alex'
      fill_in 'Lastname', with: 'Smith'
      fill_in 'Username', with: 'alexsmith'
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
    end

    scenario 'valid attributes' do
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(page).to have_content 'Alex alexsmith Smith'
    end

    scenario 'mismatched passwords' do
      fill_in 'Password confirmation', with: '12345679'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match"
    end
  end

  scenario 'User tryes to sign up with invalid attributes' do
    click_on 'Sign up'

    expect(page).to have_content "Firstname can't be blank"
    expect(page).to have_content "Lastname can't be blank"
    expect(page).to have_content "Username can't be blank"
    expect(page).to have_content "Email can't be blank"
  end
end
