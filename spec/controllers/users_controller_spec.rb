require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    before { get :show, params: { id: user } }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #current_user_home' do
    context 'for authenticated user' do
      it 'redirects to current_user profile' do
        login(user)
        get :current_user_home
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :current_user_home
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
