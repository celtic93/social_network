class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_liked, only: %i(create)
  before_action :find_like, only: %i(destroy)

  def create
    @like = @liked.likes.create(user: current_user)
  end

  def destroy
    @like.destroy
  end

  private

  def find_liked
    klass = [Post].find {|c| params["#{c.name.underscore}_id"] }
    @liked = klass.find(params["#{klass.name.underscore}_id"])
  end

  def find_like
    klass = [Post].find {|c| c.name == params[:likeable_type] }
    @liked = klass.find(params[:id])
    @like = current_user.likes.find_by(likeable: @liked)
  end
end
