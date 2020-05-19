require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }
  let(:friendships) { create_list(:friendship, 2, user: user) }
  let(:requested_friendships) { create_list(:friendship, 2, :requested, user: user) }
  let(:pending_friendships) { create_list(:friendship, 2, :pending, user: user) }
  let(:user_friends) { [friendships[0].friend, friendships[1].friend] }
  let(:user_requested_friends) { [requested_friendships[0].friend, requested_friendships[1].friend] }
  let(:user_pending_friends) { [pending_friendships[0].friend, pending_friendships[1].friend] }

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

  describe 'GET #make_request' do
    context 'for authenticated user' do
      before { login(user) }

      it 'saves a new friendships in database' do
        expect { get :make_request, params: { user_id: other_user.id }, format: :js }.to change(Friendship, :count).by(2)
      end

      it 'renders make_request view' do
        get :make_request, params: { user_id: other_user.id }, format: :js
        expect(response).to render_template :make_request
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :make_request, params: { user_id: other_user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #accept' do
    let(:pending_user) { pending_friendships[0].friend }
    let!(:friendship) { create(:friendship, :requested, user: pending_user, friend: user) }

    context 'for authenticated user' do
      before { login(pending_user) }

      it 'adds a new friend for user' do
        expect { get :accept, params: { user_id: user.id }, format: :js }.to change(user.friends, :count).by(1)
      end

      it 'adds a new friend for pending_user' do
        expect { get :accept, params: { user_id: user.id }, format: :js }.to change(pending_user.friends, :count).by(1)
      end

      it 'removes requested friend for user' do
        expect { get :accept, params: { user_id: user.id }, format: :js }.to change(user.pending_friends, :count).by(-1)
      end

      it 'remove pending friend for pending_user' do
        expect { get :accept, params: { user_id: user.id }, format: :js }.to change(pending_user.requested_friends, :count).by(-1)
      end

      it 'renders accept view' do
        get :accept, params: { user_id: user.id }, format: :js
        expect(response).to render_template :accept
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :accept, params: { user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #reject' do
    let(:pending_user) { pending_friendships[0].friend }
    let!(:friendship) { create(:friendship, :requested, user: pending_user, friend: user) }

    context 'for authenticated user' do
      before { login(pending_user) }

      it 'deletes friendships from database' do
        expect { get :reject, params: { user_id: user.id }, format: :js }.to change(Friendship, :count).by(-2)
      end

      it 'renders reject view' do
        get :reject, params: { user_id: user.id }, format: :js
        expect(response).to render_template :reject
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :reject, params: { user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #cancel' do
    let(:pending_user) { pending_friendships[0].friend }
    let!(:friendship) { create(:friendship, :requested, user: pending_user, friend: user) }

    context 'for authenticated user' do
      before { login(user) }

      it 'deletes friendships from database' do
        expect { get :cancel, params: { user_id: pending_user.id }, format: :js }.to change(Friendship, :count).by(-2)
      end

      it 'renders cancel view' do
        get :cancel, params: { user_id: pending_user.id }, format: :js
        expect(response).to render_template :cancel
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :cancel, params: { user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #unfriend' do
    let(:friend) { friendships[0].friend }
    let!(:friendship) { create(:friendship, user: friend, friend: user) }

    context 'for authenticated user' do
      before { login(user) }

      it 'deletes friendships from database' do
        expect { get :unfriend, params: { user_id: friend.id }, format: :js }.to change(Friendship, :count).by(-2)
      end

      it 'renders unfriend view' do
        get :unfriend, params: { user_id: friend.id }, format: :js
        expect(response).to render_template :unfriend
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :unfriend, params: { user_id: user.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
