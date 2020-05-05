require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user_post) { create(:post) }
  let(:user) { user_post.user }
  let(:other_user) { create(:user) }
  let!(:comment) { create(:comment, user: user, commentable: user_post) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new comment in database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         post_id: user_post,
                                         user: user }, format: :js }.to change(user_post.comments, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { comment: attributes_for(:comment),
                                post_id: user_post,
                                user: user }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid),
                                         post_id: user_post,
                                         user: user }, format: :js }.to_not change(user_post.comments, :count)
      end

      it 'renders create view' do
        post :create, params: { comment: attributes_for(:comment, :invalid),
                                         post_id: user_post,
                                         user: user }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         post_id: user_post,
                                         user: user }, format: :js }.to_not change(user_post.comments, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { comment: attributes_for(:comment),
                                         post_id: user_post,
                                         user: user }, format: :js

        expect(response).to have_http_status 401
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        login(user)
        patch :update, params: { id: comment, user_id: user, comment: { body: 'New body' } }, format: :js
      end

      it 'assigns the requested comment to @comment' do
        expect(assigns(:comment)).to eq comment
      end

      it 'changes comment attributes' do
        comment.reload
        expect(comment.body).to eq 'New body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: comment,
                                 user_id: user,
                                 comment: attributes_for(:comment, :invalid) }, format: :js
      end

      it 'assigns the requested comment to @comment' do
        expect(assigns(:comment)).to eq comment
      end

      it 'does not change comment' do
        comment.reload
        expect(comment.body).to eq 'Comment Body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context "someone else's comment" do
      before do
        login(other_user)
        patch :update, params: { id: comment, user_id: user, comment: { body: 'New body' } }, format: :js
      end

      it 'does not change comment' do
        comment.reload
        expect(comment.body).to eq 'Comment Body'
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before do
        patch :update, params: { id: comment, user_id: user, comment: { body: 'New body' } }, format: :js
      end

      it 'does not change comment' do
        comment.reload
        expect(comment.body).to eq 'Comment Body'
      end

      it 'status 401: Unauthorized' do
        expect(response.status).to eq 401
      end
    end
  end
end
