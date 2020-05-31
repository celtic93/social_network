class FriendshipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  before_action :check_request, only: :create
  before_action :find_request, only: :destroy

  def create
    @friendship_request = FriendshipRequest.create(requestor: current_user, receiver: @user)
  end

  def destroy
    @friendship_request.destroy
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def check_request
    find_request
    redirect_to root_path, notice: 'You can not do this' if @friendship_request
  end

  def find_request
    @friendship_request = FriendshipRequest.find_by(requestor: current_user, receiver: @user) ||
                          FriendshipRequest.find_by(requestor: @user, receiver: current_user)
  end
end
