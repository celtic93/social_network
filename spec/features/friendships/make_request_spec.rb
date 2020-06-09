require 'rails_helper'

feature 'User can make request for friendship' do
  given(:users) { create_list(:user, 2) }

  scenario 'Authenticated user tryes to make request', js: true do
    sign_in(users[0])
    visit user_path(users[1])

    within '.friend-link' do
      expect(page).to_not have_content 'Cancel request'
      click_on 'Add friend'
      expect(page).to have_content 'Cancel request'
    end
  end

  scenario 'Unauthenticated user tryes to make request' do
    visit user_path(users[0])
    expect(page).to_not have_selector '.friend-link'
    expect(page).to_not have_content 'Add friend'
  end
end
