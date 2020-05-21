require 'rails_helper'

feature 'User can accept request for friendship' do
  given(:friendship) { create(:friendship, :requested) }
  given(:user) { friendship.user }
  given(:friend) { friendship.friend }
  given!(:friendship_2) { create(:friendship, :pending, user: friend, friend: user) }

  describe 'Authenticated user tryes to accept request', js: true do
    scenario 'on user profile page', js: true do
      sign_in(user)
      visit user_path(friend)

      within '.friend-link' do
        expect(page).to_not have_content 'Unfriend'
        click_on 'Accept'
        expect(page).to have_content 'Unfriend'
      end
    end

    scenario 'on his friends page', js: true do
      sign_in(user)
      visit user_friendships_path(user)

      expect(page).to_not have_content 'Unfriend'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname

      click_on 'Requests'
      expect(page).to have_content friend.firstname
      expect(page).to have_content friend.lastname

      click_on 'Accept'
      expect(page).to_not have_content friend.firstname
      expect(page).to_not have_content friend.lastname

      click_on 'Friends'
      expect(page).to have_content friend.firstname
      expect(page).to have_content friend.lastname
      expect(page).to have_content 'Unfriend'
    end
  end

  scenario 'Unauthenticated user tryes to make request' do
    visit user_path(user)
    expect(page).to_not have_selector '.friend-link'
    expect(page).to_not have_content 'Accept'
  end
end
