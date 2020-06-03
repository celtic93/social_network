require 'rails_helper'

feature 'User can cancel request for friendship' do
  given(:friendship_request) { create(:friendship_request) }
  given(:user) { friendship_request.requestor }
  given(:friend) { friendship_request.receiver }

  describe 'Authenticated user tryes to cancel request', js: true do
    scenario 'on user profile page', js: true do
      sign_in(user)
      visit user_path(friend)

      within '.friend-link' do
        expect(page).to_not have_content 'Add friend'
        click_on 'Cancel request'
        expect(page).to have_content 'Add friend'
      end
    end

    scenario 'on his friends page', js: true do
      sign_in(user)
      click_on 'My friends'

      expect(page).to_not have_content 'Unfriend'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname
      
      click_on 'Requests'

      expect(page).to have_content friend.firstname
      expect(page).to have_content friend.lastname

      click_on 'Cancel request'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname

      click_on 'Friends'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname
      expect(page).to_not have_content 'Unfriend'
    end
  end

  scenario 'Unauthenticated user tryes to cancel request' do
    visit user_path(user)
    expect(page).to_not have_selector '.friend-link'
    expect(page).to_not have_content 'Cancel request'
    expect(page).to_not have_content 'My friends'
  end
end
