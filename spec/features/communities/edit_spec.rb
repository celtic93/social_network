require 'rails_helper'

feature 'User can edit community' do
  given(:community) { create(:community) }
  given(:user) { community.user }
  given(:other_user) { create(:user) }

  describe 'Authenticated user tryes to edit' do
    scenario 'his community', js: true do
      sign_in(user)
      visit community_path(community)
      expect(page).to have_content community.name
      expect(page).to have_content community.description
      expect(page).to_not have_content 'New name'
      expect(page).to_not have_content 'New description'
      click_on 'Edit community'

      expect(page).to have_field('community[name]', with: community.name)
      expect(page).to have_field('community[description]', with: community.description)

      fill_in 'Name', with: 'New name'
      fill_in 'Description', with: 'New description'

      click_on 'Save'

      expect(page).to have_content 'Changes successfully saved.'

      visit community_path(community)

      expect(page).to_not have_content community.name
      expect(page).to_not have_content community.description
      expect(page).to have_content 'New name'
      expect(page).to have_content 'New description'
    end

    scenario 'his community with errors', js: true do
      sign_in(user)
      visit community_path(community)
      click_on 'Edit community'

      fill_in 'Name', with: ''
      fill_in 'Description', with: ''

      click_on 'Save'

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Description can't be blank"
    end

    scenario "someone else's community" do
      sign_in(other_user)
      visit community_path(community)

      expect(page).to_not have_link 'Edit community'
    end
  end

  scenario 'Unauthenticated user tryes to edit community' do
    visit community_path(community)
    expect(page).to_not have_link 'Edit community'
  end
end
