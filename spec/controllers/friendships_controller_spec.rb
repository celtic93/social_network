require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let!(:friendships) { create_list(:friendship, 2, friend_a: user) }
  let!(:requested_friendships) { create_list(:friendship_request, 2, requestor: user) }
  let!(:pending_friendships) { create_list(:friendship_request, 2, receiver: user) }
  let(:user_friends) { [friendships[0].friend_b, friendships[1].friend_b] }
  let(:user_requested_friends) { [requested_friendships[0].receiver, requested_friendships[1].receiver] }
  let(:user_pending_friends) { [pending_friendships[0].requestor, pending_friendships[1].requestor] }

  describe 'GET #index' do
    context 'for authenticated user' do
      before do
        login(user)
        get :index, params: { user_id: user.id }
      end

      it 'populates an array of all user friends' do
        expect(assigns(:friends)).to match_array(user_friends)
      end

      it 'populates an array of all user requested friends' do
        expect(assigns(:requested_friends)).to match_array(user_requested_friends)
      end

      it 'populates an array of all user pending friends' do
        expect(assigns(:pending_friends)).to match_array(user_pending_friends)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context "for someone else's friends" do
      it 'redirects to root page' do
        login(other_user)
        get :index, params: { user_id: user.id }
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :index, params: { user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'for users with friendship request' do
      before { login(user) }

      it 'assigns @friendship_request' do
        post :create, params: { user_id: user_pending_friends[0].id }, format: :js
        expect(assigns(:friendship_request)).to eq(pending_friendships[0])
      end

      it 'deletes friendship request from database' do
        expect { post :create, params: { user_id: user_pending_friends[0].id },
                               format: :js }.to change(FriendshipRequest, :count).by(-1)
      end

      it 'saves friendship in database' do
        expect { post :create, params: { user_id: user_pending_friends[0].id },
                               format: :js }.to change(Friendship, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { user_id: user_pending_friends[0].id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for users with no friendship request' do
      before { login(user) }

      it 'do not delete friendship request from database' do
        expect { post :create, params: { user_id: other_user.id },
                               format: :js }.to_not change(FriendshipRequest, :count)
      end

      it 'do not save friendship in database' do
        expect { post :create, params: { user_id: other_user.id },
                               format: :js }.to_not change(Friendship, :count)
      end

      it 'renders create view' do
        post :create, params: { user_id: other_user.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        post :create, params: { user_id: other_user.id }, format: :js
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for users with friendship' do
      before { login(user) }

      it 'assigns @user' do
        delete :destroy, params: { user_id: user.id, id: user_friends[0].id }, format: :js
        expect(assigns(:user)).to eq(user_friends[0])
      end

      it 'deletes friendship from database' do
        expect { delete :destroy, params: { user_id: user.id, id: user_friends[0].id },
                                  format: :js }.to change(Friendship, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { user_id: user.id, id: user_friends[0].id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for users with no friendship' do
      before { login(user) }

      it 'assigns @user' do
        delete :destroy, params: { user_id: user.id, id: other_user.id }, format: :js
        expect(assigns(:user)).to eq(other_user)
      end

      it 'do not delete friendship from database' do
        expect { delete :destroy, params: { user_id: user.id, id: other_user.id },
                                  format: :js }.to_not change(Friendship, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { user_id: user.id, id: other_user.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        delete :destroy, params: { user_id: user.id, id: user_friends[0].id }, format: :js
        expect(response).to have_http_status 401
      end
    end
  end
end
