require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let(:firstname) { user.firstname }
  let(:lastname) { user.lastname }
  let(:username) { user.username }
  let(:info) { user.info }

  describe 'GET #show' do
    before { get :show, params: { id: user } }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq user
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    context 'for authenticated user' do
      context 'for his profile' do
        before do
          login(user)
          get :edit, params: { id: user }
        end

        it 'assigns the requested user to @user' do
          expect(assigns(:user)).to eq user
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context "for someone else's profile" do
        before do
          login(user)
          get :edit, params: { id: other_user }
        end

        it 'do not assigns the requested user to @user' do
          expect(assigns(:user)).to_not eq user
        end

        it 'redirects to root page' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      before { get :edit, params: { id: user } }

      it 'do not assigns the requested user to @user' do
        expect(assigns(:user)).to_not eq user
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested user to @user' do
        patch :update, params: { id: user, user: attributes_for(:user) }, format: :js
        expect(assigns(:user)).to eq user
      end

      it 'changes user attributes' do
        patch :update, params: { id: user, user: {  firstname: 'new firstname',
                                                    lastname: 'new lastname',
                                                    username: 'new username',
                                                    info: 'new info' } }, format: :js
        user.reload

        expect(user.firstname).to eq 'new firstname'
        expect(user.lastname).to eq 'new lastname'
        expect(user.username).to eq 'new username'
        expect(user.info).to eq 'new info'
      end

      it 'renders update view' do
        patch :update, params: { id: user, user: attributes_for(:user) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: user, user: attributes_for(:user, :invalid) }, format: :js
      end

      it 'does not change user' do
        user.reload

        expect(user.firstname).to eq firstname
        expect(user.lastname).to eq lastname
        expect(user.username).to eq username
        expect(user.info).to eq info
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context "for someone else's profile" do
      before do
        login(other_user)
        patch :update, params: { id: user, user: {  firstname: 'new firstname',
                                                    lastname: 'new lastname',
                                                    username: 'new username',
                                                    info: 'new info' } }
      end

      it 'does not change user' do
        user.reload

        expect(user.firstname).to eq firstname
        expect(user.lastname).to eq lastname
        expect(user.username).to eq username
        expect(user.info).to eq info
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before do
        patch :update, params: { id: user, user: {  firstname: 'new firstname',
                                                    lastname: 'new lastname',
                                                    username: 'new username',
                                                    info: 'new info' } }
      end

      it 'does not change user' do
        user.reload

        expect(user.firstname).to eq firstname
        expect(user.lastname).to eq lastname
        expect(user.username).to eq username
        expect(user.info).to eq info
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
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
