require 'rails_helper'

feature 'User can subscribe for users and communities' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given(:community) { create(:community) }
  given!(:other_user_post) { create(:post, user: other_user, publisher: other_user, body: 'Other User Post') }
  given!(:community_post) { create(:post, user: community.user, publisher: community, body: 'Community Post') }

  scenario 'Authenticated user tryes to subscribe', js: true do
    sign_in(user)
    visit feed_path

    expect(page).to_not have_content 'Other User Post'
    expect(page).to_not have_content 'Community Post'

    visit user_path(other_user)
    click_on 'Follow'

    visit community_path(community)
    click_on 'Follow'

    visit feed_path

    expect(page).to have_content 'Other User Post'
    expect(page).to have_content 'Community Post'
  end

  scenario 'Unauthenticated user tryes to subscribe' do
    visit user_path(other_user)
    expect(page).to_not have_link 'Follow'

    visit community_path(community)
    expect(page).to_not have_link 'Follow'
  end
end
