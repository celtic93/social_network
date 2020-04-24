class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def current_user_home
    redirect_to current_user || new_user_registration_path
  end
end
