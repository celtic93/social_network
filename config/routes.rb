Rails.application.routes.draw do
  devise_for :users
  
  resources :users, except: %i(index new create) do
    resources :posts, only: %i(create edit update destroy)
  end

  root to: 'users#current_user_home'
end
