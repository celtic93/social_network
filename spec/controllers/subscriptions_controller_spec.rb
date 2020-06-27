require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:users) { create_list(:user, 2) }
  let(:user) { users[0] }
  let(:other_user) { users[1] }

  describe 'GET #index' do
    context 'for authenticated user' do
      let(:community) { create(:community) }
      let!(:subscription) { create(:subscription, subscriber: user, publisher: community) }
      let!(:post) { create(:post, user: community.user, publisher: community)}

      before do
        login(user)
        get :index
      end

      it 'assigns the user news to @news' do
        expect(assigns(:news)).to eq [post]
      end

      it 'assigns a new comment to @new_comment' do
        expect(assigns(:new_comment)).to be_a_new(Comment)
      end

      it 'renders index view' do
        expect(response).to render_template :index
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

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      context 'for his subscription' do
        let!(:subscription) { create(:subscription, subscriber: user, publisher: other_user) }

        before { login(user) }

        it 'assigns other_user to @publisher' do
          delete :destroy, params: { publisher_type: other_user.class.name,
                                     id: other_user.id }, format: :js
          expect(assigns(:publisher)).to eq other_user
        end

        it 'deletes the subscription from database' do
          expect { delete :destroy, params: { publisher_type: other_user.class.name,
                                              id: other_user.id }, format: :js }.to change(user.subscriptions, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { publisher_type: other_user.class.name,
                                     id: other_user.id }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context "for someone else's subscription" do
        let!(:subscription) { create(:subscription, publisher: other_user) }

        before { login(user) }

        it 'does not delete the subscription from database' do
          expect { delete :destroy, params: { publisher_type: other_user.class.name,
                                              id: other_user.id }, format: :js }.to_not change(Subscription, :count)
        end

        it 'redirects to root page' do
          delete :destroy, params: { publisher_type: other_user.class.name,
                                     id: other_user.id }, format: :js
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'for unauthenticated user' do
      it "don't delete the subscription from database" do
        expect { delete :destroy, params: { publisher_type: other_user.class.name,
                                            id: other_user.id }, format: :js }.to_not change(Subscription, :count)
      end

      it 'redirects to sign up page' do
        delete :destroy, params: { publisher_type: other_user.class.name,
                                   id: other_user.id }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
