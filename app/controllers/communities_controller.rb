class CommunitiesController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_community, except: %i(index new)
  before_action :check_author, only: %i(edit update destroy)

  def index
    
  end

  def show
    
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.communities.new(community_params)    
    @community.save ? redirect_to(@community) : render(:create)
  end

  def edit
  end

  def update
    @community.update(community_params)
  end

  private

  def find_community
    @community = Community.find(params[:id])
  end

  def check_author
    redirect_to root_path, alert: 'You can not do this' unless current_user.author?(@community)
  end

  def community_params
    params.require(:community).permit(:name, :description)
  end
end
