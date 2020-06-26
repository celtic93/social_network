require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }

  describe 'POST #create' do
    context 'for authenticated user' do
      context 'with no subscription' do
        before { login(user) }

        it 'assigns other_user to @publisher' do
          post :create, params: { user_id: other_user, format: :js }
          expect(assigns(:publisher)).to eq other_user
        end

        it 'saves a new subscription in database' do
          expect { post :create, params: { user_id: other_user }, format: :js }.to change(user.subscriptions, :count).by(1)
        end

        it 'renders create' do
          post :create, params: { user_id: other_user, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with subscription' do
        let!(:subscription) { create(:subscription, subscriber: user, publisher: other_user) }

        before { login(user) }

        it 'assigns other_user to @publisher' do
          post :create, params: { user_id: other_user, format: :js }
          expect(assigns(:publisher)).to eq other_user
        end

        it 'does not save a new subscription in database' do
          expect { post :create, params: { user_id: other_user }, format: :js }.to_not change(user.subscriptions, :count)
        end

        it 'renders create' do
          post :create, params: { user_id: other_user, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'for unauthenticated user' do
      it 'does not save a new subscription in database' do
        expect { post :create, params: { user_id: other_user }, format: :js }.to_not change(Subscription, :count)
      end

      it 'redirects to sign up page' do
        post :create, params: { user_id: other_user, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
end
