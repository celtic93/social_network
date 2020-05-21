require 'rails_helper'

feature 'User can like post' do
  given(:post) { create(:post) }
  given(:user) { post.user }
  given!(:like) { create(:like, user: user, likeable: post) }

  scenario 'Authenticated user tryes to remove like from post', js: true do
    sign_in(user)

    within ".like-post-#{post.id}-link" do
      expect(page).to_not have_content '0 ❤'
      click_on '1 💛'
      expect(page).to have_content '0 ❤'
    end
  end

  scenario 'Unauthenticated user tryes to remove like from post' do
    visit user_path(user)
    expect(page).to_not have_selector ".like-post-#{post.id}-link"
  end
end
