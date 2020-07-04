require 'rails_helper'

feature 'User can search for users' do
  let!(:user) { create(:user, firstname: 'John') }
  let!(:other_user) { create(:user, lastname: 'Smith') }

  describe 'Authenticated user tryes to search for user' do
    scenario 'with query' do
      sign_in(user)
      click_on 'My friends'
      expect(page).to_not have_content 'John'
      expect(page).to_not have_content 'Smith'

      fill_in id: 'query', with: 'John'
      click_on 'Search'
      expect(page).to have_content 'John'
      expect(page).to_not have_content 'Smith'

      fill_in id: 'query', with: 'Smith'
      click_on 'Search'
      expect(page).to_not have_content 'John'
      expect(page).to have_content 'Smith'
    end

    scenario 'without query' do
      sign_in(user)
      click_on 'My friends'
      expect(page).to_not have_content 'Nobody was found'

      click_on 'Search'
      expect(page).to have_content 'Nobody was found'
    end
  end

  describe 'Unauthenticated user tryes to search for user' do
    scenario 'with query' do
      visit search_path
      expect(page).to_not have_content 'John'
      expect(page).to_not have_content 'Smith'

      fill_in id: 'query', with: 'John'
      click_on 'Search'
      expect(page).to have_content 'John'
      expect(page).to_not have_content 'Smith'

      fill_in id: 'query', with: 'Smith'
      click_on 'Search'
      expect(page).to_not have_content 'John'
      expect(page).to have_content 'Smith'
    end

    scenario 'without query' do
      visit search_path
      expect(page).to_not have_content 'Nobody was found'

      click_on 'Search'
      expect(page).to have_content 'Nobody was found'
    end
  end
end
