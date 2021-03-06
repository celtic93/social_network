require 'rails_helper'

feature 'User can unfriend friend' do
  given(:friendship) { create(:friendship) }
  given(:user) { friendship.friend_a }
  given(:friend) { friendship.friend_b }

  describe 'Authenticated user tryes to unfriend friend', js: true do
    scenario 'on friend profile page', js: true do
      sign_in(user)
      visit user_path(friend)

      within '.friend-link' do
        expect(page).to_not have_content 'Add friend'
        click_on 'Unfriend'
        expect(page).to have_content 'Add friend'
      end
    end

    scenario 'on his friends page', js: true do
      sign_in(user)
      click_on 'My friends'

      expect(page).to have_content 'Friends 1'
      expect(page).to have_content friend.firstname
      expect(page).to have_content friend.lastname

      click_on 'Unfriend'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname
      expect(page).to have_content 'Friends 0'
    end
  end

  scenario 'Unauthenticated user tryes to unfriend friend' do
    visit user_path(user)
    expect(page).to_not have_selector '.friend-link'
    expect(page).to_not have_content 'Unfriend'
    expect(page).to_not have_content 'My friends'
  end
end
