class CommunitiesController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_community, only: %i(show)

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

  private

  def find_community
    @community = Community.find(params[:id])
  end

  def community_params
    params.require(:community).permit(:name, :description)
  end
end
