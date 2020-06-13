class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_publisher, only: %i(create)
  before_action :find_post, except: %i(create)
  before_action :check_author, except: %i(create)

  def create
    @post = @publisher.publications.create(post_params.merge(user: current_user))
    @new_comment = Comment.new
  end

  def update
    @post.update(post_params)
    @new_comment = Comment.new
  end

  def destroy
    @post.destroy
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def find_publisher
    klass = [User, Community].find {|c| params["#{c.name.underscore}_id"] }
    @publisher = klass.find(params["#{klass.name.underscore}_id"])
  end

  def check_author
    redirect_to root_path, alert: 'You can not do this' unless current_user.author?(@post)
  end

  def post_params
    params.require(:post).permit(:body)
  end
end
