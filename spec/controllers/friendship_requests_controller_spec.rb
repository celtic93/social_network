require 'rails_helper'

RSpec.describe FriendshipRequestsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let!(:friendship) { create(:friendship, friend_a: user) }
  let!(:pending_friendship) { create(:friendship_request, receiver: user) }
  let(:user_friend) { friendship.friend_b }
  let(:user_pending_friend) { pending_friendship.requestor }

  describe 'POST #create' do
    context 'for users with no friendship request' do
      before { login(user) }

      it 'saves friendship request in database' do
        expect { post :create, params: { id: other_user.id },
                               format: :js }.to change(FriendshipRequest, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { id: other_user.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for users with friendship request' do
      before { login(user) }

      it 'assigns @friendship_request' do
        post :create, params: { id: user_pending_friend.id }, format: :js
        expect(assigns(:friendship_request)).to eq(pending_friendship)
      end

      it 'do not saves friendship request in database' do
        expect { post :create, params: { id: user_pending_friend.id },
                               format: :js }.to_not change(FriendshipRequest, :count)
      end

      it 'renders create view' do
        post :create, params: { id: user_pending_friend.id }, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context 'for users with friendship' do
      before { login(user) }

      it 'do not saves friendship request in database' do
        expect { post :create, params: { id: user_friend.id },
                               format: :js }.to_not change(FriendshipRequest, :count)
      end

      it 'renders create view' do
        post :create, params: { id: user_friend.id }, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        post :create, params: { id: other_user.id }, format: :js
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context "for requestor's friendship request" do
      before { login(user_pending_friend) }

      it 'assigns @user' do
        delete :destroy, params: { id: user.id }, format: :js
        expect(assigns(:user)).to eq(user)
      end

      it 'deletes friendship request from database' do
        expect { delete :destroy, params: { id: user.id },
                                  format: :js }.to change(FriendshipRequest, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: user.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "for receiver's friendship request" do
      before { login(user) }

      it 'assigns @user' do
        delete :destroy, params: { id: user_pending_friend.id }, format: :js
        expect(assigns(:user)).to eq(user_pending_friend)
      end

      it 'deletes friendship request from database' do
        expect { delete :destroy, params: { id: user_pending_friend.id },
                                  format: :js }.to change(FriendshipRequest, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: user_pending_friend.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for users with no friendship request' do
      before { login(user) }

      it 'assigns @user' do
        delete :destroy, params: { id: other_user.id }, format: :js
        expect(assigns(:user)).to eq(other_user)
      end

      it 'do not delete friendship request from database' do
        expect { delete :destroy, params: { id: other_user.id },
                                  format: :js }.to_not change(FriendshipRequest, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: other_user.id }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        delete :destroy, params: { id: other_user.id }, format: :js
        expect(response).to have_http_status 401
      end
    end
  end
end
