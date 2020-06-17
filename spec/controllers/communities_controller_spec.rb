require 'rails_helper'

RSpec.describe CommunitiesController, type: :controller do
  let!(:community) { create(:community) }
  let(:user) { community.user }
  let(:other_user) { create(:user) }
  let(:name) { community.name }
  let(:description) { community.description }

  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: community } }

    it 'assigns the requested community to @community' do
      expect(assigns(:community)).to eq community
    end

    it 'assigns a new post to @post' do
      expect(assigns(:post)).to be_a_new(Post)
    end

    it 'assigns a new comment to @new_comment' do
      expect(assigns(:new_comment)).to be_a_new(Comment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'for authenticated user' do
      before do
        login(user)
        get :new
      end

      it 'assigns the new community to @community' do
        expect(assigns(:community)).to be_a_new(Community)
      end

      it 'renders show view' do
        expect(response).to render_template :new
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign up page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new community in database' do
        expect { post :create, params: { community: attributes_for(:community) } }
               .to change(user.communities, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { community: attributes_for(:community) }
        expect(response).to redirect_to assigns(:community)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save a new post in database' do
        expect { post :create, params: { community: attributes_for(:community, :invalid) }, format: :js }
               .to_not change(user.communities, :count)
      end

      it 'renders create' do
        post :create, params: { community: attributes_for(:community, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for unauthenticated user' do
      it 'does not save a new post in database' do
        expect { post :create, params: { community: attributes_for(:community) } }
               .to_not change(Community, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { community: attributes_for(:community) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'for authenticated user' do
      context 'for his community' do
        before do
          login(user)
          get :edit, params: { id: community }
        end

        it 'assigns the requested community to @community' do
          expect(assigns(:community)).to eq community
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context "for someone else's community" do
        before do
          login(other_user)
          get :edit, params: { id: community }
        end

        it 'assigns the requested community to @community' do
          expect(assigns(:community)).to eq community
        end

        it 'redirects to root page' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to sign in page' do
        get :edit, params: { id: community }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before { login(user) }

      it 'assigns the requested community to @community' do
        patch :update, params: { id: community, community: attributes_for(:community) }, format: :js
        expect(assigns(:community)).to eq community
      end

      it 'changes community attributes' do
        patch :update, params: { id: community, community: {  name: 'new name',
                                                              description: 'new description' } }, format: :js
        community.reload

        expect(community.name).to eq 'new name'
        expect(community.description).to eq 'new description'
      end

      it 'renders update view' do
        patch :update, params: { id: community, community: attributes_for(:community) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: community, community: attributes_for(:user, :invalid) }, format: :js
      end

      it 'does not change community' do
        community.reload

        expect(community.name).to eq name
        expect(community.description).to eq description
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context "for someone else's community" do
      before do
        login(other_user)
        patch :update, params: { id: community, community: {  name: 'new name',
                                                              description: 'new description' } }
      end

      it 'does not change community' do
        community.reload

        expect(community.name).to eq name
        expect(community.description).to eq description
      end

      it 'redirects to root page' do
        expect(response).to redirect_to root_path
      end
    end

    context 'for unauthenticated user' do
      before do
        patch :update, params: { id: community, community: {  name: 'new name',
                                                              description: 'new description' } }
      end

      it 'does not change community' do
        community.reload

        expect(community.name).to eq name
        expect(community.description).to eq description
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      context 'for his community' do
        before { login(user) }

        it 'deletes the user community' do
          expect { delete :destroy, params: { id: community } }.to change(Community, :count).by(-1)
        end

        it 'redirects to root page' do
          delete :destroy, params: { id: community }
          expect(response).to redirect_to root_path
        end
      end

      context "for someone else's profile" do
        before { login(other_user) }

        it "don't delete the community profile" do
          expect { delete :destroy, params: { id: community } }.to_not change(Community, :count)
        end

        it 'redirects to root page' do
          delete :destroy, params: { id: community }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the community" do
        expect { delete :destroy, params: { id: community } }.to_not change(Community, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { id: community }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
