class SearchesController < ApplicationController
  def index
    @results = Movie.search(params[:query])
  end
end
