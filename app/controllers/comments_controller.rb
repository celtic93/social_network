class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commented, only: %i(create)
  before_action :find_comment, only: %i(update)

  def create
    @comment = @commented.comments.create(comment_params.merge(user: current_user))
  end

  def update
    if current_user.author?(@comment)
      @comment.update(comment_params)
    else
      redirect_to root_path, alert: 'You can not do this' 
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commented
    klass = [Post].find {|c| params["#{c.name.underscore}_id"] }
    @commented = klass.find(params["#{klass.name.underscore}_id"])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end
end
