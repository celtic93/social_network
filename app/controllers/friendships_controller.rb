class FriendshipsController < ApplicationController
  protect_from_forgery only: :index

  before_action :authenticate_user!
  before_action :find_user

  def index
    if current_user.id == @user.id
      @friends = @user.friends
      @requested_friends = @user.requested_friends
      @pending_friends = @user.pending_friends
    else
      redirect_to root_path, alert: 'You can not do this'
    end
  end

  def make_request
    Friendship.request(current_user, @user)
  end

  def accept
    if current_user.requested_friends.include?(@user)
      Friendship.accept(current_user, @user)
    end
  end

  def reject
    if current_user.requested_friends.include?(@user)
      Friendship.breakup(current_user, @user)
    end
  end

  def cancel
    if current_user.pending_friends.include?(@user)
      Friendship.breakup(current_user, @user)
    end
  end

  def unfriend
    if current_user.friends.include?(@user)
      Friendship.breakup(current_user, @user)
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
