Rails.application.routes.draw do
  devise_for :users
  
  resources :users, except: %i(index new create) do
    resources :posts, shallow: true, only: %i(create edit update destroy) do
      resources :comments, shallow: true, only: %i(create edit update destroy)
      resources :likes, shallow: true, only: %i(create destroy)
    end
  end

  root to: 'users#current_user_home'
end
