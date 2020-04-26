class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i(show current_user_home)
  before_action :find_user, except: %i(current_user_home)
  before_action :check_profile_owner, except: %i(show current_user_home)

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
  end

  def current_user_home
    redirect_to current_user || new_user_registration_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :username, :info)
  end

  def check_profile_owner
    redirect_to root_path, alert: 'You can not do this' unless current_user.id == @user.id
  end
end
