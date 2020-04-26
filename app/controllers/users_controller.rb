class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i(show current_user_home)
  before_action :find_user
  #before_action :check_author

  def show
  end

  def edit
  end

  def current_user_home
    redirect_to current_user || new_user_registration_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
