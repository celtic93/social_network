require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user_post) { create(:post) }
  let(:user) { user_post.user }
  let(:other_user) { create(:user) }
  let!(:like) { create(:like, user: user) }

  describe 'POST #create' do
    context 'for authenticated user' do
      before { login(user) }

      it 'saves a new like in database' do
        expect { post :create, params: { post_id: user_post },
                                         format: :js }.to change(user_post.likes, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { post_id: user_post, format: :js }
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

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      context 'for his like' do
        before { login(user) }

        it 'deletes the like from database' do
          expect { delete :destroy, params: { likeable_type: like.likeable.class.name,
                                              id: like.likeable }, format: :js }.to change(user.likes, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { likeable_type: like.likeable.class.name,
                                     id: like.likeable }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "for someone else's like" do
        before { login(other_user) }

        it "don't delete the like from database" do
          expect { delete :destroy, params: { likeable_type: like.likeable.class.name,
                                              id: like.likeable }, format: :js }.to_not change(Like, :count)
        end

        it 'redirects to root page' do
          delete :destroy, params: { likeable_type: like.likeable.class.name,
                                     id: like.likeable }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the like from database" do
        expect { delete :destroy, params: { likeable_type: like.likeable.class.name,
                                            id: like.likeable }, format: :js }.to_not change(Like, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { likeable_type: like.likeable.class.name,
                                   id: like.likeable }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
