class LikesController < ApplicationController
  before_action :find_liked, only: %i(create)

  def create
    @like = @liked.likes.create(user: current_user)
  end

  private

  def find_liked
    klass = [Post].find {|c| params["#{c.name.underscore}_id"] }
    @liked = klass.find(params["#{klass.name.underscore}_id"])
  end
end
