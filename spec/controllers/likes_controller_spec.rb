require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user_post) { create(:post) }
  let(:user) { user_post.user }

  describe 'POST #create' do
    context 'for authenticated user' do
      before { login(user) }

      it 'saves a new like in database' do
        expect { post :create, params: { user_id: user,
                                         post_id: user_post,
                                         like: attributes_for(:like) }, format: :js }.to change(user_post.likes, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { user_id: user,
                                post_id: user_post,
                                like: attributes_for(:like), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'does not save a new like in database' do
        expect { post :create, params: { user_id: user,
                                         post_id: user_post,
                                         like: attributes_for(:like) }, format: :js }.to_not change(user_post.likes, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { user_id: user,
                                post_id: user_post,
                                like: attributes_for(:like), format: :js }

        expect(response.status).to eq 401
      end
    end
  end
end
