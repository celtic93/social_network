require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user_post) { create(:post) }
  let(:other_user) { create(:user) }
  let(:user) { user_post.user }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new post in database' do
        expect { post :create, params: { user_id: user,
                                         post: attributes_for(:post) }, format: :js }.to change(user.posts, :count).by(1)

      end

      it 'renders create' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save a new post in database' do
        expect { post :create, params: { user_id: user,
                                         post: attributes_for(:post, :invalid) }, format: :js }.to_not change(user.posts, :count)
      end

      it 'renders create' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'does not save a new post in database' do
        expect { post :create, params: { user_id: user,
                                         post: attributes_for(:post, :invalid) }, format: :js }.to_not change(user.posts, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post, :invalid) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        login(user)
        patch :update, params: { id: user_post, user_id: user, post: { body: 'New body' } }, format: :js
      end

      it 'assigns the requested post to @post' do
        expect(assigns(:post)).to eq user_post
      end

      it 'changes post attributes' do
        user_post.reload
        expect(user_post.body).to eq 'New body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: user_post,
                                 user_id: user,
                                 post: attributes_for(:post, :invalid) }, format: :js
      end

      it 'assigns the requested post to @post' do
        expect(assigns(:post)).to eq user_post
      end

      it 'does not change post' do
        user_post.reload
        expect(user_post.body).to eq 'Post body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context "someone else's post" do
      before do
        login(other_user)
        patch :update, params: { id: user_post, user_id: user, post: { body: 'New body' } }, format: :js
      end

      it 'does not change post' do
        user_post.reload
        expect(user_post.body).to eq 'Post body'
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before do
        patch :update, params: { id: user_post, user_id: user, post: { body: 'New body' } }, format: :js
      end

      it 'does not change post' do
        user_post.reload
        expect(user_post.body).to eq 'Post body'
      end

      it 'status 401: Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end
end
