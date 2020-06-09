class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, except: :destroy
  before_action :find_request, only: :create
  before_action :find_friendship, only: :destroy

  def index
    if current_user.id == @user.id
      @friends = @user.friends
      @requested_friends = @user.requested_friends
      @pending_friends = @user.pending_friends
    else
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  def create
    if @friendship_request
      Friendship.transaction do
        @friendship_request.destroy
        Friendship.create!(friend_a: current_user, friend_b: @user)
      end
    end
  end

  def destroy
    @friendship.destroy if @friendship
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_request
    @friendship_request = FriendshipRequest.find_by(requestor: @user, receiver: current_user)
  end

  def find_friendship
    @user = User.find(params[:id])
    @friendship = Friendship.find_by(friend_a: @user, friend_b: current_user) ||
                  Friendship.find_by(friend_b: @user, friend_a: current_user)
  end
end
