require 'rails_helper'

feature 'User can edit profile' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }

  describe 'Authenticated user tryes to edit' do
    scenario 'his profile', js: true do
      sign_in(user)
      click_on 'Edit profile'

      expect(page).to have_field('user[firstname]', with: user.firstname)
      expect(page).to have_field('user[lastname]', with: user.lastname)
      expect(page).to have_field('user[username]', with: user.username)
      expect(page).to have_field('user[info]', with: user.info)

      fill_in 'Firstname', with: 'New Firstname'
      fill_in 'Lastname', with: 'New Lastname'
      fill_in 'Username', with: 'New Username'
      fill_in 'Info', with: 'New Info'

      click_on 'Save'

      expect(page).to have_content 'Changes successfully saved.'

      click_on 'My profile'

      expect(page).to_not have_content user.firstname
      expect(page).to_not have_content user.lastname
      expect(page).to_not have_content user.username
      expect(page).to_not have_content user.info

      expect(page).to have_content 'New Firstname'
      expect(page).to have_content 'New Lastname'
      expect(page).to have_content 'New Username'
      expect(page).to have_content 'New Info'
    end

    scenario 'his profile with errors', js: true do
      sign_in(user)
      click_on 'Edit profile'

      fill_in 'Firstname', with: ''
      fill_in 'Lastname', with: ''
      fill_in 'Username', with: ''

      click_on 'Save'

      expect(page).to have_content "Firstname can't be blank"
      expect(page).to have_content "Lastname can't be blank"
      expect(page).to have_content "Username can't be blank"
    end

    scenario "someone else's profile" do
      sign_in(user)
      visit user_path(other_user)

      expect(page).to_not have_link 'Edit profile'
    end
  end

  scenario 'Unauthenticated user tryes to edit profile' do
    visit user_path(user)
    expect(page).to_not have_link 'Edit profile'
  end
end
