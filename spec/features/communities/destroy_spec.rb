require 'rails_helper'

feature 'User can delete community' do
  given(:community) { create(:community) }
  given(:user) { community.user }

  scenario 'Authenticated user tryes to delete his community' do
    sign_in(user)
    visit community_path(community)
    click_on 'Edit community'
    click_on 'Delete community'

    expect(page).to have_content 'Community successfully deleted.'
  end
end
