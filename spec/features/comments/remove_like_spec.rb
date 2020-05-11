require 'rails_helper'

feature 'User can like comment' do
  given(:comment) { create(:comment) }
  given(:user) { comment.commentable.user }
  given!(:like) { create(:like, user: user, likeable: comment) }

  scenario 'Authenticated user tryes to like comment', js: true do
    sign_in(user)

    within ".like-comment-#{comment.id}-link" do
      expect(page).to_not have_content '0 ❤'
      click_on '1 💛'
      expect(page).to have_content '0 ❤'
    end
  end

  scenario 'Unauthenticated user tryes to like comment' do
    visit user_path(user)
    expect(page).to_not have_selector ".like-comment-#{comment.id}-link"
  end
end
