require 'rails_helper'

feature 'User can see personal profile' do
  let(:users) { create_list(:user, 2) }

  scenario 'Authenticated user tryes to see personal profile' do
    sign_in(users[0])
    visit user_path(users[1])
    click_on 'My profile'

    expect(page).to have_content users[0].firstname
    expect(page).to have_content users[0].lastname
    expect(page).to have_content users[0].username
    expect(page).to have_content users[0].info
  end

  scenario 'Unauthenticated user tryes to see personal profile' do
    visit user_path(users[0])
    expect(page).to_not have_link 'My profile'
  end
end
