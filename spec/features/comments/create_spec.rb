require 'rails_helper'

feature 'User can create comment' do
  given(:post) { create(:post) }
  given(:user) { post.user }

  describe 'Authenticated user tryes to create comment' do
    scenario 'with valid attributes', js: true do
      sign_in(user)
      expect(page).to_not have_content 'This is comment'
      expect(page).to_not have_selector "#comment-form-post-#{post.id}"

      click_on 'Comment'

      expect(page).to have_selector "#comment-form-post-#{post.id}"

      within "#comment-form-post-#{post.id}" do
        fill_in id: "comment-post-#{post.id}", with: 'This is comment'
        click_on 'Comment'
      end

      expect(page).to have_content 'This is comment'
      expect(page).to_not have_selector "#comment-form-post-#{post.id}"
    end

    scenario 'with invalid attributes', js: true do
      sign_in(user)
      
      expect(page).to_not have_content 'This is comment'
      expect(page).to_not have_selector "#comment-form-post-#{post.id}"

      click_on 'Comment'

      expect(page).to have_selector "#comment-form-post-#{post.id}"

      within "#comment-form-post-#{post.id}" do
        fill_in id: "comment-post-#{post.id}", with: ''
        click_on 'Comment'
      end

      expect(page).to_not have_content 'This is comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tryes to create post' do
    visit user_path(user)
    expect(page).to_not have_link 'Comment'
  end
end
