class HomesController < ApplicationController
  def index
    @posts = Post.all
  end
end
