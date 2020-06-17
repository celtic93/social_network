require 'rails_helper'

feature 'User can delete community post' do
  given(:community) { create(:community) }
  given(:user) { community.user }
  given(:other_user) { create(:user) }
  given!(:post) { create(:post, publisher: community, user: user) }

  describe 'Authenticated user tryes to delete post' do
    scenario 'on his community page', js: true do
      sign_in(user)
      visit community_path(community)

      within '.posts' do
        expect(page).to have_content 'Post body'
        click_on 'Delete'
        accept_alert 'Are you sure?'
        expect(page).to_not have_content 'Post body'
        expect(page).to have_content 'Post successfully deleted.'
      end
    end

    scenario "on someone else's community page" do
      sign_in(other_user)
      visit community_path(community)
      expect(page).to have_content post.body
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user tryes to delete post' do
    visit community_path(community)
    expect(page).to have_content post.body
    expect(page).to_not have_link 'Delete'
  end
end
