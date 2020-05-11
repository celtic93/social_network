require 'rails_helper'

feature 'User can create post' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }

  describe 'Authenticated user tryes to create post' do
    scenario 'on his profile page', js: true do
      sign_in(user)
      expect(page).to_not have_content 'Post Body'

      within '.new-post' do
        fill_in 'Body', with: 'Post Body'
        click_on 'Post'
      end

      within '.posts' do
        expect(page).to have_content 'Post Body'
        expect(page).to have_link "#{user.firstname} #{user.lastname}"
      end
    end

    scenario 'on his profile page with errors', js: true do
      sign_in(user)
      
      within '.new-post' do
        fill_in 'Body', with: ''
        click_on 'Post'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "on someone else's profile page" do
      sign_in(user)
      visit user_path(other_user)

      expect(page).to_not have_link 'Post'
    end
  end

  scenario 'Unauthenticated user tryes to create post' do
    visit user_path(user)
    expect(page).to_not have_link 'Post'
  end
end
