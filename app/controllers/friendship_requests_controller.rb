class FriendshipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user
  before_action :find_request
  before_action :check_request, only: :create
  

  def create
    @friendship_request = FriendshipRequest.create(requestor: current_user, receiver: @user)
  end

  def destroy
    @friendship_request.destroy if @friendship_request
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def check_request
    if @friendship_request || current_user.friends.include?(@user)
      redirect_to root_path, notice: 'You can not do this'
    end
  end

  def find_request
    @friendship_request = FriendshipRequest.find_by(requestor: current_user, receiver: @user) ||
                          FriendshipRequest.find_by(requestor: @user, receiver: current_user)
  end
end
