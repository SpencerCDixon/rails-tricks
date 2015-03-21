class ActorsController < ApplicationController
  def index
    @actors = Actor.page(params[:page])
  end

  def show
    @actor = Actor.find(params[:id])
  end
end
