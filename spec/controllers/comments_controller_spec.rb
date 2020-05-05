require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user_post) { create(:post) }
  let(:user) { user_post.user }

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
      it 'does not save the post' do
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
end
