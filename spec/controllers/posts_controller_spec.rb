require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }

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
end
