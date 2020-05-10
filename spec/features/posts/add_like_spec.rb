require 'rails_helper'

feature 'User can like post' do
  given(:post) { create(:post) }
  given(:user) { post.user }

  scenario 'Authenticated user tryes to like post', js: true do
    sign_in(user)

    within ".like-post-#{post.id}-link" do
      expect(page).to_not have_content '1 ❤'
      click_on '0 ❤'
      expect(page).to have_content '1 ❤'
    end
  end

  scenario 'Unauthenticated user tryes to like post' do
    visit user_path(user)
    expect(page).to_not have_selector ".like-post-#{post.id}-link"
  end
end
