require 'rails_helper'

feature 'User can browse community' do
  given(:community) { create(:community) }
  given(:user) { community.user }

  scenario 'Authenticated user tryes to browse community' do
    sign_in(user)
    visit community_path(community)

    expect(page).to have_content community.name
    expect(page).to have_content community.description
  end

  scenario 'Unauthenticated user tryes to browse community' do
    visit community_path(community)

    expect(page).to have_content community.name
    expect(page).to have_content community.description
  end
end
