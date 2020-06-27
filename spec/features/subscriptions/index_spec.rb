require 'rails_helper'

feature 'User can browse publications followed users and communities' do
  given(:users) { create_list(:user, 2) }
  given(:user) { users[0] }
  given(:other_user) { users[1] }
  given(:community) { create(:community) }
  given!(:user_subscription) { create(:subscription, subscriber: user, publisher: other_user) }
  given!(:community_subscription) { create(:subscription, subscriber: user, publisher: community) }
  given!(:other_user_post) { create(:post, user: other_user, publisher: other_user, body: 'Other User Post') }
  given!(:community_post) { create(:post, user: community.user, publisher: community, body: 'Community Post') }
  given!(:post) { create(:post, body: 'Other Post') }

  scenario 'Authenticated user tryes to browse feed' do
    sign_in(user)
    visit feed_path

    expect(page).to have_content 'Other User Post'
    expect(page).to have_content 'Community Post'
    expect(page).to_not have_content 'Other Post'
  end

  scenario 'Unauthenticated user tryes to browse feed' do
    visit feed_path
    expect(page).to_not have_selector '.posts'
    expect(page).to_not have_link 'News'
    expect(page).to_not have_content 'Sign In'
  end
end
