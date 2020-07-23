require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:user_post) { create(:post) }
  let(:other_user) { create(:user) }
  let(:user) { user_post.user }
  let(:community) { create(:community, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns user to @publisher' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post), format: :js }
        expect(assigns(:publisher)).to eq user
      end

      it 'saves a new post in database' do
        expect { post :create, params: { user_id: user,
                                         post: attributes_for(:post) }, format: :js }.to change(user.publications, :count).by(1)
      end

      it 'assigns a new comment to @new_comment' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post), format: :js }
        expect(assigns(:new_comment)).to be_a_new(Comment)
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
                                         post: attributes_for(:post, :invalid) }, format: :js }.to_not change(user.publications, :count)
      end

      it 'renders create' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for publisher user' do
      before { login(user) }

      it 'assigns community to @publisher' do
        post :create, params: { community_id: community,
                                post: attributes_for(:post), format: :js }
        expect(assigns(:publisher)).to eq community
      end

      it 'saves a new post in database' do
        expect { post :create, params: { community_id: community,
                                         post: attributes_for(:post) }, format: :js }.to change(community.publications, :count).by(1)
      end

      it 'assigns a new comment to @new_comment' do
        post :create, params: { community_id: community,
                                post: attributes_for(:post), format: :js }
        expect(assigns(:new_comment)).to be_a_new(Comment)
      end

      it 'renders create' do
        post :create, params: { community_id: community,
                                post: attributes_for(:post), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'for not publisher user' do
      before { login(other_user) }

      it 'assigns community to @publisher' do
        post :create, params: { community_id: community,
                                post: attributes_for(:post), format: :js }
        expect(assigns(:publisher)).to eq community
      end

      it 'do not saves a new post in database' do
        expect { post :create, params: { community_id: community,
                                         post: attributes_for(:post) }, format: :js }.to_not change(community.publications, :count)
      end

      it 'redirects to root page' do
        post :create, params: { community_id: community,
                                post: attributes_for(:post), format: :js }
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      it 'does not save a new post in database' do
        expect { post :create, params: { user_id: user,
                                         post: attributes_for(:post) }, format: :js }.to_not change(user.posts, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { user_id: user,
                                post: attributes_for(:post) }

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

      it 'assigns a new comment to @new_comment' do
        expect(assigns(:new_comment)).to be_a_new(Comment)
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

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      context 'for his post' do
        before { login(user) }

        it 'deletes the post' do
          expect { delete :destroy, params: { user_id: user, id: user_post }, format: :js }.to change(user.publications, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { user_id: user, id: user_post }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "for someone else's post" do
        before { login(other_user) }

        it "don't delete the post" do
          expect { delete :destroy, params: { user_id: user, id: user_post } }.to_not change(Post, :count)
        end

        it 'redirects to root page' do
          delete :destroy, params: { user_id: user, id: user_post }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the post" do
        expect { delete :destroy, params: { user_id: user, id: user_post } }.to_not change(Post, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { user_id: user, id: user_post }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
