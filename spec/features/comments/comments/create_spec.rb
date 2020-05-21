require 'rails_helper'

feature 'User can create comment for comment' do
  given(:post) { create(:post) }
  given(:comment) { create(:comment, commentable: post) }
  given(:user) { post.user }

  describe 'Authenticated user tryes to create comment' do
    scenario 'with valid attributes', js: true do
      sign_in(user)

      within "#comment-#{comment.id}"
        expect(page).to_not have_content 'This is comment'
        expect(page).to_not have_selector "#comment-form-comment-#{comment.id}"

        click_on 'Comment'

        expect(page).to have_selector "#comment-form-comment-#{comment.id}"

        within "#comment-form-comment-#{comment.id}" do
          fill_in id: "comment-comment-#{comment.id}", with: 'This is comment'
          click_on 'Comment'
        end

        expect(page).to have_content 'This is comment'
        expect(page).to_not have_selector "#comment-form-comment-#{comment.id}"
      end
    end

    scenario 'with invalid attributes', js: true do
      sign_in(user)

      within "#comment-#{comment.id}"
        expect(page).to_not have_content 'This is comment'
        expect(page).to_not have_selector "#comment-form-comment-#{comment.id}"

        click_on 'Comment'

        expect(page).to have_selector "#comment-form-comment-#{comment.id}"

        within "#comment-form-comment-#{comment.id}" do
          fill_in id: "comment-comment-#{comment.id}", with: ''
          click_on 'Comment'
        end

        expect(page).to_not have_content 'This is comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tryes to create comment' do
    visit user_path(user)
    expect(page).to_not have_link 'Comment'
  end
end
