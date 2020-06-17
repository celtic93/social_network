require 'rails_helper'

feature 'User can edit post for community' do
  given(:community) { create(:community) }
  given(:user) { community.user }
  given(:other_user) { create(:user) }
  given!(:post) { create(:post, publisher: community, user: user) }

  describe 'Authenticated user tryes to edit post' do
    scenario 'on his community page', js: true do
      sign_in(user)
      visit community_path(community)
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

    scenario 'on his community page with errors', js: true do
      sign_in(user)
      visit community_path(community)

      within '.posts' do
        click_on 'Edit'

        expect(page).to have_selector "textarea#post-#{post.id}"
        fill_in id: "post-#{post.id}", with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "on someone else's community page" do
      sign_in(other_user)
      visit community_path(community)

      expect(page).to have_content post.body

      within '.posts' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tryes to edit post' do
    visit community_path(community)
    expect(page).to have_content post.body
    expect(page).to_not have_link 'Edit'
  end
end
