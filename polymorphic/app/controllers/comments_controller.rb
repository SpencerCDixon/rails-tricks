class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to post_path(@post), notice: "Comment Created"
    else
      render 'posts#show'
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :rating)
  end
end
