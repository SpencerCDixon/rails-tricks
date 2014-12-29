class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    binding.pry

    if @comment.save
      binding.pry
      redirect_to root_path
    else
      render 'posts#show'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
