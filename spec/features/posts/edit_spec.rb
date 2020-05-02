require 'rails_helper'

feature 'User can edit post' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given!(:post) { create(:post, user: user) }
  given!(:other_post) { create(:post, user: other_user) }

  describe 'Authenticated user tryes to edit post' do
    scenario 'on his profile page', js: true do
      sign_in(user)
      expect(page).to have_content 'Post body'
      expect(page).to_not have_content 'Edit Post Body'
      expect(page).to_not have_selector "textarea#post-#{post.id}"

      within '.posts' do
        click_on 'Edit'

        expect(page).to have_selector "textarea#post-#{post.id}"
        fill_in id: "post-#{post.id}", with: 'Edit Post Body'
        click_on 'Save'
      end

      expect(page).to_not have_content 'Post body'
      expect(page).to have_content 'Edit Post Body'
      expect(page).to_not have_selector "textarea#post-#{post.id}"
    end

    scenario 'on his profile page with errors', js: true do
      sign_in(user)

      within '.posts' do
        click_on 'Edit'

        expect(page).to have_selector "textarea#post-#{post.id}"
        fill_in id: "post-#{post.id}", with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "on someone else's profile page" do
      sign_in(user)
      visit user_path(other_user)
      expect(page).to have_content other_post.body
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user tryes to create post' do
    visit user_path(user)
    expect(page).to have_content other_post.body
    expect(page).to_not have_link 'Edit'
  end
end
