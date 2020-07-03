class SearchController < ApplicationController
  def index
    @users = User.search(search_params[:query])
  end

  private

  def search_params
    params.permit(:query)
  end
end
