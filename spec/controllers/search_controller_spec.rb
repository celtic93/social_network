require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create(:user, firstname: 'firstname') }

  describe 'GET #index' do
    context 'with query' do
      before { get :index, params: { query: 'firstname' } }

      it 'assigns the user to @users' do
        expect(assigns(:users)).to eq [user]
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'without query' do
      before { get :index, params: { query: '' } }

      it 'assigns nil to @users' do
        expect(assigns(:users)).to be_nil
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end
end
