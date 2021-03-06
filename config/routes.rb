Rails.application.routes.draw do
  devise_for :users

  concern :publisher do
    resources :posts, shallow: true, only: %i(create edit update destroy) do
      resources :comments, shallow: true, only: %i(create edit update destroy) do
        resources :comments, shallow: true, only: %i(create edit update destroy)
        resources :likes, shallow: true, only: %i(create destroy)
      end
      
      resources :likes, shallow: true, only: %i(create destroy)
    end

    resources :subscriptions, shallow: true, only: %i(index create destroy)
  end
  
  resources :users, except: %i(index new create), concerns: [:publisher] do
    resources :friendships, only: %i(index create destroy)
  end

  resources :friendship_requests, only: %i(create destroy)
  resources :communities, concerns: [:publisher]

  get 'feed', to: 'subscriptions#index'
  get 'search', to: 'search#index'
  root to: 'users#current_user_home'
end
