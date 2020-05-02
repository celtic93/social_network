class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, except: %i(create)

  def create
    @post = current_user.posts.create(post_params)
  end

  def update
    @post.update(post_params)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
