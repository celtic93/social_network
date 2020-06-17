require 'rails_helper'

feature 'User can create post on community page' do
  given(:community) { create(:community) }
  given(:user) { community.user }
  given(:other_user) { create(:user) }

  describe 'Authenticated user tryes to create post' do
    scenario 'on his community page', js: true do
      sign_in(user)
      visit community_path(community)
      expect(page).to_not have_content 'Post Body'

      within '.new-post' do
        fill_in id: "post_body", with: 'Post Body'
        click_on 'Post'
      end

      within '.posts' do
        expect(page).to have_content 'Post Body'
        expect(page).to have_link "#{community.name}"
      end
    end

    scenario 'on his community page with errors', js: true do
      sign_in(user)
      visit community_path(community)
      
      within '.new-post' do
        fill_in id: "post_body", with: ''
        click_on 'Post'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "on someone else's community page" do
      sign_in(other_user)
      visit community_path(community)

      expect(page).to_not have_link 'Post'
    end
  end

  scenario 'Unauthenticated user tryes to create post' do
    visit community_path(community)
    expect(page).to_not have_link 'Post'
  end
end
