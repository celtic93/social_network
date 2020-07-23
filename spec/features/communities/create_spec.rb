require 'rails_helper'

feature 'User can create community' do
  given(:user) { create(:user) }

  describe 'Authenticated user tryes to create community' do
    scenario 'with valid attributes' do
      sign_in(user)
      visit communities_path
      click_on 'Create community'

      fill_in 'Name', with: 'New community name'
      fill_in 'Description', with: 'New community description'
      click_on 'Create'

      expect(page).to have_content 'New community name'
      expect(page).to have_content 'New community description'
    end

    scenario 'with invalid attributes', js: true do
      sign_in(user)
      visit communities_path
      click_on 'Create community'

      fill_in 'Name', with: ''
      fill_in 'Description', with: ''
      click_on 'Create'

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Description can't be blank"
    end
  end

  scenario 'Unauthenticated user tryes to create community' do
    visit communities_path
    expect(page).to_not have_link 'Create community'
  end
end
