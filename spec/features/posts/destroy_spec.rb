require 'rails_helper'

feature 'User can delete post' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given!(:post) { create(:post, user: user) }
  given!(:other_post) { create(:post, user: other_user) }

  describe 'Authenticated user tryes to delete post' do
    scenario 'on his profile page', js: true do
      sign_in(user)
      
      within '.posts' do
        expect(page).to have_content 'Post body'
        click_on 'Delete'
        accept_alert 'Are you sure?'
        expect(page).to_not have_content 'Post body'
      end
    end

    scenario "on someone else's profile page" do
      sign_in(user)
      visit user_path(other_user)
      expect(page).to have_content other_post.body
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tryes to delete post' do
    visit user_path(user)
    expect(page).to have_content other_post.body
    expect(page).to_not have_link 'Delete'
  end
end
