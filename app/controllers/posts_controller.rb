class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = current_user.posts.create(post_params)
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
