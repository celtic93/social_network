require 'rails_helper'

feature 'User can edit comment' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given!(:post) { create(:post, user: user) }
  given!(:comment) { create(:comment, user: user, commentable: post) }
  given!(:other_comment) { create(:comment, user: other_user, commentable: post) }

  describe 'Authenticated user tryes to edit' do
    scenario 'his comment', js: true do
      sign_in(user)

      within "#comment-#{comment.id}" do
        click_on 'Edit'
        fill_in id: "edit-comment-#{comment.id}", with: 'Edit Comment Edit Body'
        click_on 'Save'

        expect(page).to_not have_content 'Comment Body'
        expect(page).to have_content 'Edit Comment Edit Body'
        expect(page).to_not have_selector "textarea#edit-comment-#{comment.id}"
      end
    end

    scenario 'his comment with errors', js: true do
      sign_in(user)

      within "#comment-#{comment.id}" do
        click_on 'Edit'
        fill_in id: "edit-comment-#{comment.id}", with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "someone else's comment" do
      sign_in(user)

      within "#comment-#{other_comment.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tryes to create post' do
    visit user_path(user)

    within "#comment-#{comment.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
