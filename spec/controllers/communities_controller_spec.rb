require 'rails_helper'

RSpec.describe CommunitiesController, type: :controller do
  let(:community) { create(:community) }
  let(:user) { community.user }

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
end
