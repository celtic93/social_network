Rails.application.routes.draw do
  devise_for :users
  
  resources :users, except: %i(index new create) do
    resources :posts, shallow: true, only: %i(create edit update destroy) do
      resources :comments, shallow: true, only: %i(create edit update destroy) do
        resources :comments, shallow: true, only: %i(create edit update destroy)
        resources :likes, shallow: true, only: %i(create destroy)
      end
      
      resources :likes, shallow: true, only: %i(create destroy)
    end

    resources :friendships, only: %i(index destroy) do
      get 'make_request', on: :collection
      get 'accept', on: :collection
      get 'reject', on: :collection
      get 'cancel', on: :collection
      get 'unfriend', on: :collection
    end
  end

  root to: 'users#current_user_home'
end
