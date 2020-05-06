require 'rails_helper'

feature 'User can delete comment' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given(:post) { create(:post, user: user) }
  given(:other_post) { create(:post, user: other_user) }
  given!(:comment) { create(:comment, user: user, commentable: post) }
  given!(:comment_of_his_post) { create(:comment, user: other_user, commentable: post) }
  given!(:other_comment) { create(:comment, user: other_user, commentable: other_post) }

  describe 'Authenticated user tryes to delete' do
    scenario 'his comment', js: true do
      sign_in(user)
      
      within "#comment-#{comment.id}" do
        expect(page).to have_content 'Comment Body'
        click_on 'Delete'
        accept_alert 'Are you sure?'
        expect(page).to_not have_content 'Comment Body'
        expect(page).to have_content 'Comment successfully deleted.'
      end
    end

    scenario 'comment of his post', js: true do
      sign_in(user)
      
      within "#comment-#{comment_of_his_post.id}" do
        expect(page).to have_content 'Comment Body'
        click_on 'Delete'
        accept_alert 'Are you sure?'
        expect(page).to_not have_content 'Comment Body'
        expect(page).to have_content 'Comment successfully deleted.'
      end
    end

    scenario "on someone else's comment" do
      sign_in(user)
      visit user_path(other_user)

      within "#comment-#{other_comment.id}" do
        expect(page).to have_content 'Comment Body'
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tryes to delete comment' do
    visit user_path(user)

    within "#comment-#{comment.id}" do
      expect(page).to have_content 'Comment Body'
      expect(page).to_not have_link 'Delete'
    end
  end
end
