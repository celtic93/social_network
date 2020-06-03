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
    
    resources :friendships, only: %i(index create destroy)
  end

  resources :friendship_requests, only: %i(create destroy)

  root to: 'users#current_user_home'
end
